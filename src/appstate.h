#ifndef APPSTATE_H
#define APPSTATE_H

#include "cache.h"

#include <gio/gio.h>
#include <glib.h>

#include <sys/param.h>

#ifndef PIXELDATA_STRUCT
#define PIXELDATA_STRUCT

typedef struct
{
        unsigned char r;
        unsigned char g;
        unsigned char b;
} PixelData;
#endif

typedef enum
{
        SONG_VIEW,
        KEYBINDINGS_VIEW,
        PLAYLIST_VIEW,
        LIBRARY_VIEW,
        SEARCH_VIEW
} ViewState;

typedef struct
{
        int mainColor;                                  // Main terminal color, when using config colors
        int titleColor;                                 // Color of the title, when using config colors
        int artistColor;                                // Artist color, when using config colors
        int enqueuedColor;                              // Color of enqueued files, when using config colors
        PixelData color;                                // The current color, when using album derived colors
        bool useConfigColors;                           // Use colors stored in config file or use an album derived color
        bool coverEnabled;                              // Show covers or not
        bool uiEnabled;                                 // Show ui or not
        bool coverAnsi;                                 // Show chafa cover (picture perfect in the right terminal), or ascii/ansi typ cover
        bool visualizerEnabled;                         // Show spectrum visualizer
        bool nerdFontsEnabled;                          // Show nerd font icons
        bool hideLogo;                                  // No rpd text at top
        bool hideHelp;                                  // No help text at top
        bool allowNotifications;                        // Send desktop notifications or not
        int visualizerHeight;                           // Height in characters of the spectrum visualizer
        int cacheLibrary;                               // Cache the library or not
        bool quitAfterStopping;                         // Exit rpd when the music stops or not
        time_t lastTimeAppRan;                          // When did this app run last, used for updating the cached library if it has been modified since that time
} UISettings;

typedef struct
{
        int chosenNodeId;                               // The id of the tree node that is chosen in library view
        bool allowChooseSongs;                          // In library view, has the user entered a folder that contains songs
        bool openedSubDir;                              // Opening a directory in an open directory.
        int numSongsAboveSubDir;                        // How many rows do we need to jump up if we close the parent directory and open one within
        int numDirectoryTreeEntries;                    // The number of entries in directory tree in library view
        int numProgressBars;                            // The number of progress dots at the bottom of track view
        volatile sig_atomic_t resizeFlag;               // Is the user resizing the terminal window
        bool resetPlaylistDisplay;                      // Should the playlist be reset, ie drawn starting from playing song
        bool doNotifyMPRISSwitched;                     // Emit mpris song switched signal
        bool doNotifyMPRISPlaying;                      // Emit mpris music is playing signal
} UIState;

typedef struct
{
        Cache *tempCache;                               // Cache for temporary files
        ViewState currentView;                          // The current view (playlist, library, track) that rpd is on
        UIState uiState;
        UISettings uiSettings;
} AppState;

static const unsigned char defaultColor = 150;

#ifndef KEYVALUEPAIR_STRUCT
#define KEYVALUEPAIR_STRUCT

typedef struct
{
        char *key;
        char *value;
} KeyValuePair;

#endif

#ifndef APPSETTINGS_STRUCT

typedef struct
{
        char path[MAXPATHLEN];
        char coverEnabled[2];
        char coverAnsi[2];
        char useConfigColors[2];
        char visualizerEnabled[2];
        char visualizerHeight[6];
        char togglePlaylist[6];
        char toggleBindings[6];
        char volumeUp[6];
        char volumeUpAlt[6];
        char volumeDown[6];
        char previousTrackAlt[6];
        char nextTrackAlt[6];
        char scrollUpAlt[6];
        char scrollDownAlt[6];
        char switchNumberedSong[6];
        char switchNumberedSongAlt[6];
        char switchNumberedSongAlt2[6];
        char togglePause[6];
        char toggleColorsDerivedFrom[6];
        char toggleVisualizer[6];
        char toggleAscii[6];
        char toggleRepeat[6];
        char toggleShuffle[6];
        char seekBackward[6];
        char seekForward[6];
        char savePlaylist[6];
        char addToMainPlaylist[6];
        char updateLibrary[6];
        char quit[6];
        char hardQuit[6];
        char hardSwitchNumberedSong[6];
        char hardPlayPause[6];
        char hardPrev[6];
        char hardNext[6];
        char hardScrollUp[6];
        char hardScrollDown[6];
        char hardShowPlaylist[6];
        char hardShowPlaylistAlt[6];
        char showPlaylistAlt[6];
        char hardShowKeys[6];
        char hardShowKeysAlt[6];
        char showKeysAlt[6];
        char hardEndOfPlaylist[6];
        char hardShowLibrary[6];
        char hardShowLibraryAlt[6];
        char showLibraryAlt[6];
        char hardShowSearch[6];
        char hardShowSearchAlt[6];
        char showSearchAlt[6];
        char hardShowTrack[6];
        char hardShowTrackAlt[6];
        char showTrackAlt[6];
        char hardNextPage[6];
        char hardPrevPage[6];
        char hardRemove[6];
        char hardRemove2[6];
        char lastVolume[12];
        char allowNotifications[2];
        char color[2];
        char artistColor[2];
        char enqueuedColor[2];
        char titleColor[2];
        char hideLogo[2];
        char hideHelp[2];
        char cacheLibrary[6];
        char tabNext[6];
} AppSettings;

#endif

#endif
