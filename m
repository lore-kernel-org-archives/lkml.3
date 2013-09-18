Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752636Ab3IRMgX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Sep 2013 08:36:23 -0400
Received: from mail-la0-f42.google.com ([209.85.215.42]:59485 "EHLO
	mail-la0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752569Ab3IRMgU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Sep 2013 08:36:20 -0400
Message-ID: <1379507774.2294.21.camel@ThinkPad-X230.localdomain>
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
Date: Wed, 18 Sep 2013 16:36:14 +0400
In-Reply-To: <52399D0B.3010909@intel.com>
References: <1379409796-29350-1-git-send-email-aaron.lu@intel.com>
	  <1379424853.3348.1.camel@ThinkPad-X230.localdomain>
	  <5238FBF5.8080405@intel.com>
	 <1379485819.2294.1.camel@ThinkPad-X230.localdomain>
	 <52399D0B.3010909@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.9.91 (3.9.91-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-09-18 at 20:31 +0800, Aaron Lu wrote:
> On 09/18/2013 02:30 PM, Igor Gnatenko wrote:
> > On Wed, 2013-09-18 at 09:03 +0800, Aaron Lu wrote:
> >> On 09/17/2013 09:34 PM, Igor Gnatenko wrote:
> >>>
> >>> Aaron, how about fix indicator on ThinkPads ?
> >>
> >> Can you please describe the problem in detail, is it that when you
> >> adjust brightness level through hotkey, there is no GUI indication?
> >> Thanks.
> >>
> >> -Aaron
> > 
> > Yes. On my ThinkPad X230 I pressing backlight hotkeys. Actually
> > brightnes changing, but have no indicator in GUI.
> 
> Oh, that's still the problem of _BCL not getting executed once for
> Lenovo thinkpad laptops. I borrowed a Thinkpad X1 this afternoon and can
> reproduce this, I'll take a look at this issue. The thinkpad-acpi module
> already has a call to _BCL but somehow that doesn't happen.
> 
> Since it's national holidays here, I'll check this issue when I got back
> to work on this Saturday. Thanks for the quick test :-)
Thanks. No problem ;-)
> 
> -Aaron


-- 
Igor Gnatenko
Fedora release 20 (Heisenbug)
Linux 3.11.1-300.fc20.x86_64

