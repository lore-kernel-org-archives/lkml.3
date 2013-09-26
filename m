Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751364Ab3IZFPX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:15:23 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:45880 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751030Ab3IZFPV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:15:21 -0400
Date: Thu, 26 Sep 2013 13:15:53 +0800
From: Aaron Lu <aaron.lu@intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-acpi@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        Daniel Vetter <daniel@ffwll.ch>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        Seth Forshee <seth.forshee@canonical.com>,
        Lee Chun-Yi <joeyli.kernel@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>,
        Igor Gnatenko <i.gnatenko.brain@gmail.com>,
        Yves-Alexis Perez <corsac@debian.org>,
        Felipe Contreras <felipe.contreras@gmail.com>,
        Henrique de Moraes Holschuh <ibm-acpi@hmh.eng.br>,
        Jani Nikula <jani.nikula@linux.intel.com>,
        Ben Jencks <ben@bjencks.net>, Steven Newbury <steve@snewbury.org.uk>,
        James Hogan <james@albanarts.com>, Kamal Mostafa <kamal@canonical.com>,
        Joerg Platte <jplatte@naasa.net>, Kalle Valo <kvalo@adurom.com>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?iso-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>,
        Mike Galbraith <bitbucket@online.de>
Subject: Re: [PATCH v3 3/4] ACPI / video: Do not register backlight if win8
 and native interface exists
Message-ID: <20130926051552.GB14158@aaronlu.linux.com>
References: <1380016052-15315-1-git-send-email-aaron.lu@intel.com>
 <1380016052-15315-4-git-send-email-aaron.lu@intel.com>
 <2597446.Ay4U1OH2zV@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2597446.Ay4U1OH2zV@vostro.rjw.lan>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 07:53:13PM +0200, Rafael J. Wysocki wrote:
> On Tuesday, September 24, 2013 05:47:31 PM Aaron Lu wrote:
> > According to Matthew Garrett, "Windows 8 leaves backlight control up
> > to individual graphics drivers rather than making ACPI calls itself.
> > There's plenty of evidence to suggest that the Intel driver for
> > Windows [8] doesn't use the ACPI interface, including the fact that
> > it's broken on a bunch of machines when the OS claims to support
> > Windows 8.  The simplest thing to do appears to be to disable the
> > ACPI backlight interface on these systems".
> > 
> > So for Win8 systems, if there is native backlight control interface
> > registered by GPU driver, ACPI video will not register its own. For
> > users who prefer to keep ACPI video's backlight interface, the existing
> > kernel cmdline option acpi_backlight=video can be used.
> 
> I think the idea is to use the aggressive default for now and we can switch the
> default back to the current behavior before the merge window in case there are
> too many problems with it?

Yes I think so.

Thanks,
Aaron
