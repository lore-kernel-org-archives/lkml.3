Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758015Ab3J2DFL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 23:05:11 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:39999 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757559Ab3J2DFJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 23:05:09 -0400
From: Masanari Iida <standby24x7@gmail.com>
To: trivial@kernel.org, linux-kernel@vger.kernel.org, tiwai@suse.de,
        alsa-devel@alsa-project.org, perex@perex.cz
Cc: rdunlap@infradead.org, Masanari Iida <standby24x7@gmail.com>
Subject: [PATCH 2/2] [trivial]doc:alsa: Fix typo in documentation/alsa
Date: Tue, 29 Oct 2013 12:05:02 +0900
Message-Id: <1383015902-29410-1-git-send-email-standby24x7@gmail.com>
X-Mailer: git-send-email 1.8.4.1.600.g3d092bf
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Correct spelling typo in documentation/alsa

Signed-off-by: Masanari Iida <standby24x7@gmail.com>
---
 Documentation/sound/alsa/ALSA-Configuration.txt | 2 +-
 Documentation/sound/alsa/Audiophile-Usb.txt     | 2 +-
 Documentation/sound/alsa/CMIPCI.txt             | 2 +-
 Documentation/sound/alsa/compress_offload.txt   | 6 +++---
 Documentation/sound/alsa/soc/DPCM.txt           | 4 ++--
 Documentation/sound/alsa/soc/dapm.txt           | 4 ++--
 6 files changed, 10 insertions(+), 10 deletions(-)

diff --git a/Documentation/sound/alsa/ALSA-Configuration.txt b/Documentation/sound/alsa/ALSA-Configuration.txt
index 95731a0..b8dd0df 100644
--- a/Documentation/sound/alsa/ALSA-Configuration.txt
+++ b/Documentation/sound/alsa/ALSA-Configuration.txt
@@ -616,7 +616,7 @@ Prior to version 0.9.0rc4 options had a 'snd_' prefix. This was removed.
 
     As default, snd-dummy drivers doesn't allocate the real buffers
     but either ignores read/write or mmap a single dummy page to all
-    buffer pages, in order to save the resouces.  If your apps need
+    buffer pages, in order to save the resources.  If your apps need
     the read/ written buffer data to be consistent, pass fake_buffer=0
     option.
 
diff --git a/Documentation/sound/alsa/Audiophile-Usb.txt b/Documentation/sound/alsa/Audiophile-Usb.txt
index 654dd3b..e7a5ed4 100644
--- a/Documentation/sound/alsa/Audiophile-Usb.txt
+++ b/Documentation/sound/alsa/Audiophile-Usb.txt
@@ -232,7 +232,7 @@ The parameter can be given:
    # modprobe snd-usb-audio index=1 device_setup=0x09
 
  * Or while configuring the modules options in your modules configuration file
-   (tipically a .conf file in /etc/modprobe.d/ directory:
+   (typically a .conf file in /etc/modprobe.d/ directory:
        alias snd-card-1 snd-usb-audio
        options snd-usb-audio index=1 device_setup=0x09
 
diff --git a/Documentation/sound/alsa/CMIPCI.txt b/Documentation/sound/alsa/CMIPCI.txt
index 16935c8..4e36e6e 100644
--- a/Documentation/sound/alsa/CMIPCI.txt
+++ b/Documentation/sound/alsa/CMIPCI.txt
@@ -87,7 +87,7 @@ with 4 channels,
 
 and use the interleaved 4 channel data.
 
-There are some control switchs affecting to the speaker connections:
+There are some control switches affecting to the speaker connections:
 
 "Line-In Mode"	- an enum control to change the behavior of line-in
 	jack.  Either "Line-In", "Rear Output" or "Bass Output" can
diff --git a/Documentation/sound/alsa/compress_offload.txt b/Documentation/sound/alsa/compress_offload.txt
index fd74ff2..630c492 100644
--- a/Documentation/sound/alsa/compress_offload.txt
+++ b/Documentation/sound/alsa/compress_offload.txt
@@ -217,12 +217,12 @@ Not supported:
   would be enabled with ALSA kcontrols.
 
 - Audio policy/resource management. This API does not provide any
-  hooks to query the utilization of the audio DSP, nor any premption
+  hooks to query the utilization of the audio DSP, nor any preemption
   mechanisms.
 
-- No notion of underun/overrun. Since the bytes written are compressed
+- No notion of underrun/overrun. Since the bytes written are compressed
   in nature and data written/read doesn't translate directly to
-  rendered output in time, this does not deal with underrun/overun and
+  rendered output in time, this does not deal with underrun/overrun and
   maybe dealt in user-library
 
 Credits:
diff --git a/Documentation/sound/alsa/soc/DPCM.txt b/Documentation/sound/alsa/soc/DPCM.txt
index aa8546f..0110180 100644
--- a/Documentation/sound/alsa/soc/DPCM.txt
+++ b/Documentation/sound/alsa/soc/DPCM.txt
@@ -192,7 +192,7 @@ This BE DAI link connects DAI0 to the codec (in this case RT5460 AIF1). It sets
 the "no_pcm" flag to mark it has a BE and sets flags for supported stream
 directions using "dpcm_playback" and "dpcm_capture" above.
 
-The BE has also flags set for ignoreing suspend and PM down time. This allows
+The BE has also flags set for ignoring suspend and PM down time. This allows
 the BE to work in a hostless mode where the host CPU is not transferring data
 like a BT phone call :-
 
@@ -328,7 +328,7 @@ The host can control the hostless link either by :-
     between both DAIs.
 
  2) Hostless FE. This FE has a virtual connection to the BE DAI links on the DAPM
-    graph. Control is then carried out by the FE as regualar PCM operations.
+    graph. Control is then carried out by the FE as regular PCM operations.
     This method gives more control over the DAI links, but requires much more
     userspace code to control the link. Its recommended to use CODEC<->CODEC
     unless your HW needs more fine grained sequencing of the PCM ops.
diff --git a/Documentation/sound/alsa/soc/dapm.txt b/Documentation/sound/alsa/soc/dapm.txt
index 7dfd88c..6faab48 100644
--- a/Documentation/sound/alsa/soc/dapm.txt
+++ b/Documentation/sound/alsa/soc/dapm.txt
@@ -30,7 +30,7 @@ There are 4 power domains within DAPM
       machine driver and responds to asynchronous events e.g when HP
       are inserted
 
-   3. Path domain - audio susbsystem signal paths
+   3. Path domain - audio subsystem signal paths
       Automatically set when mixer and mux settings are changed by the user.
       e.g. alsamixer, amixer.
 
@@ -64,7 +64,7 @@ Audio DAPM widgets fall into a number of types:-
  o Speaker    - Speaker
  o Supply     - Power or clock supply widget used by other widgets.
  o Regulator  - External regulator that supplies power to audio components.
- o Clock      -	External clock that supplies clock to audio componnents.
+ o Clock      -	External clock that supplies clock to audio components.
  o AIF IN     - Audio Interface Input (with TDM slot mask).
  o AIF OUT    - Audio Interface Output (with TDM slot mask).
  o Siggen     - Signal Generator.
-- 
1.8.4.1.600.g3d092bf

