Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752970Ab3IVKXc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:23:32 -0400
Received: from mail-la0-f41.google.com ([209.85.215.41]:63679 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752641Ab3IVKX3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:23:29 -0400
Message-ID: <1379845404.2410.1.camel@ThinkPad-X230.localdomain>
Subject: Re: [PATCH v2 0/3] Fix Win8 backlight issue
From: Igor Gnatenko <i.gnatenko.brain@gmail.com>
To: Aaron Lu <aaron.lu@intel.com>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>, "Rafael J. Wysocki" <rjw@sisk.pl>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>
Date: Sun, 22 Sep 2013 14:23:24 +0400
In-Reply-To: <523EB423.7090900@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	   <1379424853.3348.1.camel@ThinkPad-X230.localdomain>
	   <5238FBF5.8080405@intel.com>
	  <1379485819.2294.1.camel@ThinkPad-X230.localdomain>
	  <52399D0B.3010909@intel.com>
	 <1379507774.2294.21.camel@ThinkPad-X230.localdomain>
	 <523EB423.7090900@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.92 (3.9.92-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2013-09-22 at 17:10 +0800, Aaron Lu wrote:
> On 09/18/2013 08:36 PM, Igor Gnatenko wrote:
> > On Wed, 2013-09-18 at 20:31 +0800, Aaron Lu wrote:
> >> On 09/18/2013 02:30 PM, Igor Gnatenko wrote:
> >>> On Wed, 2013-09-18 at 09:03 +0800, Aaron Lu wrote:
> >>>> On 09/17/2013 09:34 PM, Igor Gnatenko wrote:
> >>>>>
> >>>>> Aaron, how about fix indicator on ThinkPads ?
> >>>>
> >>>> Can you please describe the problem in detail, is it that when you
> >>>> adjust brightness level through hotkey, there is no GUI indication?
> >>>> Thanks.
> >>>>
> >>>> -Aaron
> >>>
> >>> Yes. On my ThinkPad X230 I pressing backlight hotkeys. Actually
> >>> brightnes changing, but have no indicator in GUI.
> >>
> >> Oh, that's still the problem of _BCL not getting executed once for
> >> Lenovo thinkpad laptops. I borrowed a Thinkpad X1 this afternoon and can
> >> reproduce this, I'll take a look at this issue. The thinkpad-acpi module
> >> already has a call to _BCL but somehow that doesn't happen.
> >>
> >> Since it's national holidays here, I'll check this issue when I got back
> >> to work on this Saturday. Thanks for the quick test :-)
> > Thanks. No problem ;-)
> 
> Here is a quick fix for thinkpad-acpi.c:
> https://github.com/aaronlu/linux acpi_video_win8
> commit thinkpad-acpi: fix handle locate for video and query of _BCL.
> 
> Note that it is a separate issue specifically for thinkpad so I'll
> submit that patch in another thread.
> 
> Thanks,
> Aaron
Excellent! I've tested 3 patches from this patchset + 1 latest patch
from you branch and it is works fine. Regulating and indicating works
OK.

Thank you. I think you need to make new patch-set within 4 patches.

-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.12.0-0.rc1.git0.1.fc20.x86_64

