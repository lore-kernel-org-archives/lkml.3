Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751422Ab3HTLFo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 07:05:44 -0400
Received: from cantor2.suse.de ([195.135.220.15]:48114 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750878Ab3HTLFm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 07:05:42 -0400
Date: Tue, 20 Aug 2013 13:05:36 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Xiong Zhou <jencce.kernel@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, Ben Hutchings <ben@decadent.org.uk>,
        matthew.garrett@nebula.com, platform-driver-x86@vger.kernel.org,
        Linux-Next <linux-next@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Jim Davis <jim.epost@gmail.com>
Subject: Re: [PATCH]amilo-rfkill: add depends on i8042 in Kconfig
In-Reply-To: <CADJHv_sSn9oU-xg5qgoHRKDeyHRCqy8VuPJW5_punHd45inzsA@mail.gmail.com>
Message-ID: <alpine.LNX.2.00.1308201305160.21654@pobox.suse.cz>
References: <alpine.DEB.2.02.1306181705530.28460@M2420> <1371560680.3495.121.camel@deadeye.wl.decadent.org.uk> <51C07608.2070406@infradead.org> <CADJHv_vZiPsDUiLrFao41rRVduf+AYFm0NuvpNaCW8S3KrAjnA@mail.gmail.com> <51CC6B09.5080809@infradead.org>
 <CADJHv_sSn9oU-xg5qgoHRKDeyHRCqy8VuPJW5_punHd45inzsA@mail.gmail.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013, Xiong Zhou wrote:

> >>>>> Fix randconfig build failure for Amilo x86 platform driver.
> >>>>> AMILO_RFKILL requires SERIO_I8042 being available.
> >>>>>
> >>>>> amilo-rfkill.c:(.text+0x108b5b): undefined reference to `i8042_lock_chip'
> >>>>> amilo-rfkill.c:(.text+0x108b69): undefined reference to `i8042_command'
> >>>>> amilo-rfkill.c:(.text+0x108b71): undefined reference to `i8042_unlock_chip'
> >>>>>
> >>>>> Reported-by: Jim Davis <jim.epost@gmail.com>
> >>>>> Signed-off-by: Xiong Zhou <jencce.kernel@gmail.com>
> >>>>
> >>>> Acked-by: Ben Hutchings <ben@decadent.org.uk>
> >>>>
> >>>> But I thought somehow sent this same fix a while back...
> >>>
> >>> Yes, I reported it and sent a patch for it that you acked...
> >>> I guess my patch was never picked up.
> >>>
> >>
> >> ... Better someone pick this up.
> >>
> >
> > This build error is still occurring in linux-next (20130627).
> > I first reported it and posted a patch for it on May-15 2013.
> >
> > Please merge either patch...
> >
> > Is anybody out there?
> >
> >
> >>
> >>>>
> >>>> Ben.
> >>>>
> >>>>> ---
> >>>>>  drivers/platform/x86/Kconfig |    1 +
> >>>>>  1 file changed, 1 insertion(+)
> >>>>>
> >>>>> diff --git a/drivers/platform/x86/Kconfig b/drivers/platform/x86/Kconfig
> >>>>> index 8577261..37645b9 100644
> >>>>> --- a/drivers/platform/x86/Kconfig
> >>>>> +++ b/drivers/platform/x86/Kconfig
> >>>>> @@ -176,6 +176,7 @@ config FUJITSU_TABLET
> >>>>>  config AMILO_RFKILL
> >>>>>      tristate "Fujitsu-Siemens Amilo rfkill support"
> >>>>>      depends on RFKILL
> >>>>> +    depends on SERIO_I8042
> >>>>>      ---help---
> >>>>>        This is a driver for enabling wifi on some Fujitsu-Siemens Amilo
> >>>>>        laptops.
> >>>>
> >>>
> >>>
> >>> --
> >>> ~Randy
> >> --
> >
> >
> > --
> > ~Randy
> 
> 
> 
> cc Jiri Kosina <trivial@kernel.org>

Please resend the patch properly, it's not easy to dig it from the 
multi-depth quoted text.

-- 
Jiri Kosina
SUSE Labs
