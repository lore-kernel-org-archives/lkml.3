Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755870AbaHAUND (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 16:13:03 -0400
Received: from ausc60ps301.us.dell.com ([143.166.148.206]:50267 "EHLO
	ausc60ps301.us.dell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaHAUNA convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 16:13:00 -0400
X-Greylist: delayed 593 seconds by postgrey-1.27 at vger.kernel.org; Fri, 01 Aug 2014 16:13:00 EDT
DomainKey-Signature: s=smtpout; d=dell.com; c=nofws; q=dns;
  h=X-LoopCount0:X-IronPort-AV:From:To:CC:Date:Subject:
   Thread-Topic:Thread-Index:Message-ID:References:
   In-Reply-To:Accept-Language:Content-Language:
   X-MS-Has-Attach:X-MS-TNEF-Correlator:x-titus-version:
   x-tituslabs-classifications-30:
   x-tituslabs-classificationhash-30:x-titusconfig:
   acceptlanguage:Content-Type:Content-Transfer-Encoding:
   MIME-Version:Return-Path;
  b=g+b4mEzawloqeN5NmOeJ4rz1OTvY6L36DkZefNREybHTCNCarCe36hU1
   LBtG9OoqEyeYcXs1HhdAlAqJsnIzlfImMFXua1+uisTZGuRTHEpCKQsDW
   GjOb1apFO56U5GeWq/5gFKFsz9O6k1pDT8mLiDIYueTW3abWz4YNHT66P
   E=;
X-LoopCount0: from 10.175.216.249
X-IronPort-AV: E=Sophos;i="5.01,781,1400043600"; 
   d="scan'208";a="560841009"
From: <B_B_Singh@DELL.com>
To: <tiwai@suse.de>
CC: <gregkh@linuxfoundation.org>, <Abhay_Salunke@DELL.com>, <arnd@arndb.de>,
        <kay@vrfy.org>, <ming.lei@canonical.com>, <sr@denx.de>, <teg@jklm.no>,
        <Stuart_Hayes@DELL.com>, <Srinivas_G_Gowda@DELL.com>,
        <linux-kernel@vger.kernel.org>, <B_B_Singh@DELL.com>
Date: Fri, 1 Aug 2014 13:01:52 -0700
Subject: RE: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
Thread-Topic: patch "firmware loader: allow disabling of udev as firmware
 loader" added to driver-core tree
Thread-Index: Ac+h8Z3aPd4G4qAQS1KUSir08VRJOgLv4J5w
Message-ID: <8B2F6FFD0BD1E448853114367400A37306FE311D74@BLRX7MCDC203.AMER.DELL.COM>
References: <14048583172593@kroah.com>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBBE9@BLRX7MCDC203.AMER.DELL.COM>
	<s5h38e9mg5v.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBBF8@BLRX7MCDC203.AMER.DELL.COM>
	<s5hy4w1l0s3.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBC06@BLRX7MCDC203.AMER.DELL.COM>
	<s5hpphdkyi6.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FD6FBDAB@BLRX7MCDC203.AMER.DELL.COM>
	<s5hoawvkimg.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FE07C773@BLRX7MCDC203.AMER.DELL.COM>
	<s5h7g3frmg7.wl%tiwai@suse.de>
	<8B2F6FFD0BD1E448853114367400A37306FE07CC64@BLRX7MCDC203.AMER.DELL.COM>
 <s5hlhrrizbq.wl%tiwai@suse.de>
In-Reply-To: <s5hlhrrizbq.wl%tiwai@suse.de>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-titus-version: 3.5.29.3
x-tituslabs-classifications-30: TLPropertyRoot=Dell;Classification=No
 Restrictions;Sublabels=;
x-tituslabs-classificationhash-30: VgNFIFU9Hx+/nZJb9Kg7InDH93xORGEHKbA9IfhlEtn0qHTQFq3peMi1oTN1blvyvYuo1qgfJV7Hw3Wmh3Zl2qAkIKTy5uMotBLYynVY90QfrYbuBMDR6PhiGcJ8+jL/TRK0VzliY3AoVDXA9WbnI5NKGzNCCxKKOkcPwGOk58mV3bTRFo9skQ7WxIuKIz9sTbb/HnG7Z0IGuOudHOXnBJEwxWpno8oWkLCzSdltjKQM+lvBrq0xolISGf3WXugQtwZawQv4SCiQM2blR9VPPPcRUc3IC9x+11yeNzgXu2nibEJ5JybIdxSOAaWVyZeh
x-titusconfig: 1.4AMER
acceptlanguage: en-US
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

Sorry for the late response,  I tried with latest stable kernel 3.15.8.  surprisingly the BIOS update works even without applying the patch in both the cases.

Case I:
BIOS update is always successful with or without applying the patch https://lkml.org/lkml/2014/6/4/327, I don't see any issue related to firmware caching as seen in 3.15.5.

 1. echo 4096 > /sys/devices/platform/dell_rbu/packet_size.
 2. echo packet > /sys/devices/platform/dell_rbu/image_type.
 3. echo init > /sys/devices/platform/dell_rbu/image_type.
 4. echo 1 > /sys/class/firmware/dell_rbu/loading.
 5. cat /home/payload > /sys/class/firmware/dell_rbu/data.
 6. echo 0 > /sys/class/firmware/dell_rbu/loading.
 7. smbios-token-ctl --activate -i 0x005c

Case II:
Instead of using /sys/class/firmware path, I tried using the /lib/firmware/   path for the payload (i.e, direct load method). The BIOS update happens successfully every time even with or without applying patch. ( https://lkml.org/lkml/2014/6/4/327)

1. cat payload  > /lib/firmware/dell_rbu (copy the whole packetized data file to /lib/firmware/dell_rbu)
2. echo 4096  > /sys/devices/platform/dell_rbu/packet_size.
3. echo packet > /sys/devices/platform/dell_rbu/image_type.
4. echo init > /sys/devices/platform/dell_rbu/image_type.
5. smbios-token-ctl --activate -i 0x005c


Regards
Balaji Singh




Regards
Balaji Singh
-----Original Message-----
From: Takashi Iwai [mailto:tiwai@suse.de]
Sent: Friday, July 18, 2014 12:32 AM
To: Singh, B B
Cc: gregkh@linuxfoundation.org; Abhay_Salunke@dell.com; arnd@arndb.de; kay@vrfy.org; ming.lei@canonical.com; sr@denx.de; teg@jklm.no; Hayes, Stuart; Gowda, Srinivas G
Subject: Re: patch "firmware loader: allow disabling of udev as firmware loader" added to driver-core tree

At Thu, 17 Jul 2014 11:30:09 -0700,
wrote:
>
> Dell - Internal Use - Confidential
> Hi Takashi,
>
> I made a fresh install on a new machine, then all the below steps passed on the first attempt.

Did you test with the patch or without? Please clarify.

>
> 1. echo 4096 > /sys/devices/platform/dell_rbu/packet_size.
> 2. echo packet > /sys/devices/platform/dell_rbu/image_type.
> 3. echo init > /sys/devices/platform/dell_rbu/image_type.
> 4. echo 1 > /sys/class/firmware/dell_rbu/loading.
> 5. cat /home/payload > /sys/class/firmware/dell_rbu/data.
> 6. echo 0 > /sys/class/firmware/dell_rbu/loading.
>
> from second attempt I faced the same issue again ie., /sys/class/firmware/dell_rbu is missing. I'm working it will provide you the more details in couple of days.

I guess this is a side-effect of the firmware caching.
If so, it's been so over years.


Takashi

>
> Regards
> Balaji Singh
>
>
> -----Original Message-----
> From: Takashi Iwai [mailto:tiwai@suse.de]
> Sent: Tuesday, July 15, 2014 3:09 PM
> To: Singh, B B
> Cc: gregkh@linuxfoundation.org; Abhay_Salunke@dell.com; arnd@arndb.de;
> kay@vrfy.org; ming.lei@canonical.com; sr@denx.de; teg@jklm.no; Hayes,
> Stuart; Gowda, Srinivas G
> Subject: Re: patch "firmware loader: allow disabling of udev as
> firmware loader" added to driver-core tree
>
> At Mon, 14 Jul 2014 10:05:00 -0700,
> wrote:
> >
> > >> Did the kernel really work before patching...?
> >
> > What do you mean by "Did really kernel work"?
>
> Well, I thought you mentioned that my patch breaks the stuff.
> So I asked whether the f/w loader stuff really worked with vanilla 3.15.x kernel as is before you patch.
>
> > I was able to boot successfully with 3.15.5 kernel. But the network interfaces was never up. My guess is due to the same issue its unable to update the .fw file.
>
> But, judging from this, 3.15.5 vanilla is already broken?
> Then you'd better to bisect.
>
>
> Takashi
>
> > >>The codepath should go through _request_firmware() ->
> > >>fw_load_from_user_helper() -> _request_firmware_load(), and the sysfs file is created at this point.
> >
> > I will check this & let you know.
> >
> > Regards
> > Balaji Singh
> >
> > -----Original Message-----
> > From: Takashi Iwai [mailto:tiwai@suse.de]
> > Sent: Friday, July 11, 2014 9:12 PM
> > To: Singh, B B
> > Cc: gregkh@linuxfoundation.org; Abhay_Salunke@dell.com;
> > arnd@arndb.de; kay@vrfy.org; ming.lei@canonical.com; sr@denx.de;
> > teg@jklm.no; Hayes, Stuart; Gowda, Srinivas G
> > Subject: Re: patch "firmware loader: allow disabling of udev as
> > firmware loader" added to driver-core tree
> >
> > At Fri, 11 Jul 2014 21:03:19 +0530,
> > wrote:
> > >
> > > Hi All,
> > >
> > > Today I have tested with below config with Dell DUP R910_BIOS_GRWR5_LN_2.9.0.BIN The test failed.
> > >
> > > FW_LOADER_USER_HELPER=y,
> > > FW_LOADER_USER_HELPER_FALLBACK=n , DELL_RBU=y.
> > >
> > > To further investigate I removed DUP dependency & come up with
> > > simple steps Here are simple steps that I followed for the BIOS update. (Internally the .BIN does the same).
> > >
> > > 1. echo 4096 > /sys/devices/platform/dell_rbu/packet_size.
> > > 2. echo packet > /sys/devices/platform/dell_rbu/image_type.
> > > 3. echo init > /sys/devices/platform/dell_rbu/image_type.
> > > 4. echo 1 > /sys/class/firmware/dell_rbu/loading.
> > > 5. cat /home/payload > /sys/class/firmware/dell_rbu/data.
> > > 6. echo 0 > /sys/class/firmware/dell_rbu/loading.
> > >
> > > The failure is causing at step 4 because the entries(loading &
> > > data
> > > ) are not created for dell_rbu under /sys/class/firmware. (I mean
> > > the dell_rbu folder is not created under /sys/class/firmware/ )
> > >
> > > The return value of request_firmware_nowait is "0" & the fw_work->opt_flags value was "6" as expected.
> > >
> > > Does anyone have idea about "why entries are not created under /sys/class/firmware?"
> >
> > Did the kernel really work before patching...?
> > The codepath should go through _request_firmware() ->
> > fw_load_from_user_helper() -> _request_firmware_load(), and the sysfs file is created at this point.
> >
> >
> > Takashi
> >
> > >
> > > Regards
> > > Balaji Singh
> > >
> > > -----Original Message-----
> > > From: Takashi Iwai [mailto:tiwai@suse.de]
> > > Sent: Thursday, July 10, 2014 9:16 PM
> > > To: Singh, B B
> > > Cc: gregkh@linuxfoundation.org; Abhay_Salunke@dell.com;
> > > arnd@arndb.de; kay@vrfy.org; ming.lei@canonical.com; sr@denx.de;
> > > teg@jklm.no; Hayes, Stuart; Gowda, Srinivas G
> > > Subject: Re: patch "firmware loader: allow disabling of udev as
> > > firmware loader" added to driver-core tree
> > >
> > > At Thu, 10 Jul 2014 20:50:35 +0530,
> > > wrote:
> > > >
> > > > Hi Takashi,
> > > >
> > > > Just now I made test with below config.
> > > >
> > > > FW_LOADER_USER_HELPER=y,
> > > > FW_LOADER_USER_HELPER_FALLBACK=n , DELL_RBU=y.
> > > >
> > > > But still the test fails.
> > >
> > > Hrm, that's bad.
> > >
> > > > Will provide you more details tomorrow on why it is failing.
> > >
> > > OK, thanks. Try to put a debug print for opt_flags in _request_firmware(). This must be 6 ( = FW_OPT_NOWAIT | FW_OPT_USERHELPER).
> > >
> > >
> > > Takashi
> > >
> > > >
> > > > Regards
> > > > Balaji Singh
> > > >
> > > > -----Original Message-----
> > > > From: Takashi Iwai [mailto:tiwai@suse.de]
> > > > Sent: Thursday, July 10, 2014 8:27 PM
> > > > To: Singh, B B
> > > > Cc: gregkh@linuxfoundation.org; Abhay_Salunke@dell.com;
> > > > arnd@arndb.de; kay@vrfy.org; ming.lei@canonical.com; sr@denx.de;
> > > > teg@jklm.no; Hayes, Stuart; Gowda, Srinivas G
> > > > Subject: Re: patch "firmware loader: allow disabling of udev as
> > > > firmware loader" added to driver-core tree
> > > >
> > > > At Thu, 10 Jul 2014 20:20:39 +0530,
> > > > wrote:
> > > > >
> > > > > Hi Takashi/Tom,
> > > > >
> > > > > I have tested using the below config as mentioned in the patch & It didn't work.
> > > > >
> > > > > FW_LOADER_USER_HELPER=n
> > > > > DELL_RBU=y
> > > >
> > > > Oh, no, you chose the wrong one. The new Kconfig is FW_LOADER_USER_HELPER_FALLBACK. FW_LOADER_USER_HELPER is reverse-selected by DELL_RBU, so it must be y.
> > > > If you run "make oldconfig" once, the option should have been set automatically.
> > > >
> > > >
> > > > Takashi
> > > >
> > > > > Will try the combinations of CONFIG_FW_LOADER_USER_HELPER_FALLBACK & FW_LOADER_USER_HELPER by tomorrow & let you know the results. & also will provide the details where exactly it is failing.
> > > > >
> > > > > If you have any specific scenario to try let me know, I'll test & provide you the results.
> > > > >
> > > > > Regards
> > > > > Balaji Singh
> > > > >
> > > > > -----Original Message-----
> > > > > From: Takashi Iwai [mailto:tiwai@suse.de]
> > > > > Sent: Thursday, July 10, 2014 8:10 PM
> > > > > To: Singh, B B
> > > > > Cc: gregkh@linuxfoundation.org; Abhay_Salunke@dell.com;
> > > > > arnd@arndb.de; kay@vrfy.org; ming.lei@canonical.com;
> > > > > sr@denx.de; teg@jklm.no; Hayes, Stuart; Gowda, Srinivas G
> > > > > Subject: Re: patch "firmware loader: allow disabling of udev
> > > > > as firmware loader" added to driver-core tree
> > > > >
> > > > > At Thu, 10 Jul 2014 19:51:40 +0530,
> > > > > wrote:
> > > > > >
> > > > > > Dell - Internal Use - Confidential
> > > > > >
> > > > > > Hi All,
> > > > > >
> > > > > >
> > > > > > As I communicated earlier the test never passed with older BIOS DUPs.
> > > > >
> > > > > I didn't get any mail from you until now.
> > > > >
> > > > > > Again today I have tested with 3.15.5 kernel with below patch applied, & I don't see the BIOS getting updated. The BIOS update always failed with below patch.
> > > > >
> > > > > Double-check whether you're testing correctly. Which Kconfig option did you set? It fails no matter whether you set CONFIG_FW_LOADER_USER_HELPER_FALLBACK or not?
> > > > >
> > > > > > I'm not sure why the patch is getting committed even upon failure.
> > > > >
> > > > > It's just a miscommunication. You should have put more people involved.
> > > > >
> > > > >
> > > > > thanks,
> > > > >
> > > > > Takashi
> > > > >
> > > > > > Regards
> > > > > > Balaji Singh
> > > > > >
> > > > > >
> > > > > > -----Original Message-----
> > > > > > From: gregkh@linuxfoundation.org
> > > > > > [mailto:gregkh@linuxfoundation.org]
> > > > > > Sent: Wednesday, July 09, 2014 3:55 AM
> > > > > > To: tiwai@suse.de; Abhay_Salunke@dell.com; Singh, B B;
> > > > > > arnd@arndb.de; gregkh@linuxfoundation.org; kay@vrfy.org;
> > > > > > ming.lei@canonical.com; sr@denx.de; teg@jklm.no
> > > > > > Subject: patch "firmware loader: allow disabling of udev as
> > > > > > firmware loader" added to driver-core tree
> > > > > >
> > > > > >
> > > > > > This is a note to let you know that I've just added the
> > > > > > patch titled
> > > > > >
> > > > > > firmware loader: allow disabling of udev as firmware loader
> > > > > >
> > > > > > to my driver-core git tree which can be found at
> > > > > > git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/driver-
> > > > > > co
> > > > > > re
> > > > > > .g
> > > > > > it
> > > > > > in the driver-core-next branch.
> > > > > >
> > > > > > The patch will show up in the next release of the linux-next
> > > > > > tree (usually sometime within the next 24 hours during the
> > > > > > week.)
> > > > > >
> > > > > > The patch will also be merged in the next major kernel release during the merge window.
> > > > > >
> > > > > > If you have any questions about this process, please let me know.
> > > > > >
> > > > > >
> > > > > > >From 5a1379e8748a5cfa3eb068f812d61bde849ef76c Mon Sep 17
> > > > > > >00:00:00
> > > > > > >2001
> > > > > > From: Takashi Iwai
> > > > > > Date: Wed, 4 Jun 2014 17:48:15 +0200
> > > > > > Subject: firmware loader: allow disabling of udev as
> > > > > > firmware loader
> > > > > >
> > > > > > [The patch was originally proposed by Tom Gundersen, and
> > > > > > rewritten afterwards by me; most of changelogs below
> > > > > > borrowed from Tom's original patch -- tiwai]
> > > > > >
> > > > > > Currently (at least) the dell-rbu driver selects FW_LOADER_USER_HELPER, which means that distros can't really stop loading firmware through udev without breaking other users (though some have).
> > > > > >
> > > > > > Ideally we would remove/disable the udev firmware helper in both the kernel and in udev, but if we were to disable it in udev and not the kernel, the result would be (seemingly) hung kernels as no one would be around to cancel firmware requests.
> > > > > >
> > > > > > This patch allows udev firmware loading to be disabled while still allowing non-udev firmware loading, as done by the dell-rbu driver, to continue working. This is achieved by only using the fallback mechanism when the uevent is suppressed.
> > > > > >
> > > > > > The patch renames the user-selectable Kconfig from FW_LOADER_USER_HELPER to FW_LOADER_USER_HELPER_FALLBACK, and the former is reverse-selected by the latter or the drivers that need userhelper like dell-rbu.
> > > > > >
> > > > > > Also, the "default y" is removed together with this change, since it's been deprecated in udev upstream, thus rather better to disable it nowadays.
> > > > > >
> > > > > > Tested with
> > > > > > FW_LOADER_USER_HELPER=n
> > > > > > LATTICE_ECP3_CONFIG=y
> > > > > > DELL_RBU=y
> > > > > > and udev without the firmware loading support, but I don't have the hardware to test the lattice/dell drivers, so additional testing would be appreciated.
> > > > > >
> > > > > > Reviewed-by: Tom Gundersen
> > > > > > Cc: Ming Lei
> > > > > > Cc: Abhay Salunke
> > > > > > Cc: Stefan Roese
> > > > > > Cc: Arnd Bergmann
> > > > > > Cc: Kay Sievers
> > > > > > Tested-by: Balaji Singh
> > > > > > Signed-off-by: Takashi Iwai
> > > > > > Signed-off-by: Greg Kroah-Hartman
> > > > > > ---
> > > > > > drivers/base/Kconfig | 10 ++++++++--
> > > > > > drivers/base/firmware_class.c
> > > > > > |
> > > > > > 15 ++++++++++----- include/linux/firmware.h | 2 +-
> > > > > > 3 files changed, 19 insertions(+), 8 deletions(-)
> > > > > >
> > > > > > diff --git a/drivers/base/Kconfig b/drivers/base/Kconfig
> > > > > > index 00e13ce5cbbd..88500fed3c7a 100644
> > > > > > --- a/drivers/base/Kconfig
> > > > > > +++ b/drivers/base/Kconfig
> > > > > > @@ -149,15 +149,21 @@ config EXTRA_FIRMWARE_DIR some other directory containing the firmware files.
> > > > > >
> > > > > > config FW_LOADER_USER_HELPER
> > > > > > + bool
> > > > > > +
> > > > > > +config FW_LOADER_USER_HELPER_FALLBACK
> > > > > > bool "Fallback user-helper invocation for firmware loading"
> > > > > > depends on FW_LOADER
> > > > > > - default y
> > > > > > + select FW_LOADER_USER_HELPER
> > > > > > help
> > > > > > This option enables / disables the invocation of user-helper (e.g.
> > > > > > udev) for loading firmware files as a fallback after the
> > > > > > direct file loading in kernel fails. The user-mode helper is
> > > > > > no longer required unless you have a special firmware file
> > > > > > that
> > > > > > - resides in a non-standard path.
> > > > > > + resides in a non-standard path. Moreover, the udev support
> > > > > > + has been deprecated upstream.
> > > > > > +
> > > > > > + If you are unsure about this, say N here.
> > > > > >
> > > > > > config DEBUG_DRIVER
> > > > > > bool "Driver Core verbose debug messages"
> > > > > > diff --git a/drivers/base/firmware_class.c
> > > > > > b/drivers/base/firmware_class.c index
> > > > > > d276e33880be..46ea5f4c3bb5
> > > > > > 100644
> > > > > > --- a/drivers/base/firmware_class.c
> > > > > > +++ b/drivers/base/firmware_class.c
> > > > > > @@ -100,9 +100,14 @@ static inline long
> > > > > > firmware_loading_timeout(void) #define FW_OPT_UEVENT (1U <<
> > > > > > 0) #define FW_OPT_NOWAIT (1U << 1) #ifdef
> > > > > > CONFIG_FW_LOADER_USER_HELPER -#define FW_OPT_FALLBACK (1U <<
> > > > > > 2)
> > > > > > +#define FW_OPT_USERHELPER (1U << 2)
> > > > > > #else
> > > > > > -#define FW_OPT_FALLBACK 0
> > > > > > +#define FW_OPT_USERHELPER 0 #endif #ifdef
> > > > > > +CONFIG_FW_LOADER_USER_HELPER_FALLBACK
> > > > > > +#define FW_OPT_FALLBACK FW_OPT_USERHELPER #else #define
> > > > > > +FW_OPT_FALLBACK
> > > > > > +0
> > > > > > #endif
> > > > > >
> > > > > > struct firmware_cache {
> > > > > > @@ -1111,7 +1116,7 @@ _request_firmware(const struct
> > > > > > firmware **firmware_p, const char *name,
> > > > > >
> > > > > > ret = fw_get_filesystem_firmware(device, fw->priv); if (ret)
> > > > > > {
> > > > > > - if (opt_flags & FW_OPT_FALLBACK) {
> > > > > > + if (opt_flags & FW_OPT_USERHELPER) {
> > > > > > dev_warn(device,
> > > > > > "Direct firmware load failed with error %d\n", ret); @@
> > > > > > -1171,7
> > > > > > +1176,7 @@ request_firmware(const struct firmware
> > > > > > +**firmware_p, const
> > > > > > char *name, } EXPORT_SYMBOL(request_firmware);
> > > > > >
> > > > > > -#ifdef CONFIG_FW_LOADER_USER_HELPER
> > > > > > +#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
> > > > > > /**
> > > > > > * request_firmware: - load firmware directly without
> > > > > > usermode helper
> > > > > > * @firmware_p: pointer to firmware image @@ -1277,7 +1282,7
> > > > > > @@ request_firmware_nowait( fw_work->context = context;
> > > > > > fw_work->cont = cont; fw_work->opt_flags = FW_OPT_NOWAIT |
> > > > > > FW_OPT_FALLBACK |
> > > > > > - (uevent ? FW_OPT_UEVENT : 0);
> > > > > > + (uevent ? FW_OPT_UEVENT : FW_OPT_USERHELPER);
> > > > > >
> > > > > > if (!try_module_get(module)) { kfree(fw_work); diff --git
> > > > > > a/include/linux/firmware.h b/include/linux/firmware.h index
> > > > > > 59529330efd6..67e5b801af0c 100644
> > > > > > --- a/include/linux/firmware.h
> > > > > > +++ b/include/linux/firmware.h
> > > > > > @@ -68,7 +68,7 @@ static inline void release_firmware(const
> > > > > > struct firmware *fw)
> > > > > >
> > > > > > #endif
> > > > > >
> > > > > > -#ifdef CONFIG_FW_LOADER_USER_HELPER
> > > > > > +#ifdef CONFIG_FW_LOADER_USER_HELPER_FALLBACK
> > > > > > int request_firmware_direct(const struct firmware **fw,
> > > > > > const char *name, struct device *device); #else
> > > > > > --
> > > > > > 2.0.0.254.g50f84e3
> > > > > >
> > > > >
> > > >
> > >
> > [2 ]
> >
