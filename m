Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756576AbaCDIbY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 03:31:24 -0500
Received: from cpsmtpb-ews06.kpnxchange.com ([213.75.39.9]:60578 "EHLO
	cpsmtpb-ews06.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756384AbaCDIbX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 03:31:23 -0500
Message-ID: <1393921876.3038.3.camel@x220>
Subject: Re: 3.13 i915 brightness settings broken when going from docked ->
 undocked
From: Paul Bolle <pebolle@tiscali.nl>
To: Jani Nikula <jani.nikula@linux.intel.com>
Cc: Josh Boyer <jwboyer@fedoraproject.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        intel-gfx@lists.freedesktop.org,
        "Linux-Kernel@Vger. Kernel. Org" <linux-kernel@vger.kernel.org>,
        DRI mailing list <dri-devel@lists.freedesktop.org>
Date: Tue, 04 Mar 2014 09:31:16 +0100
In-Reply-To: <878usz8vmi.fsf@intel.com>
References: <CA+5PVA4zC1+TPWWdANnm7RuBDduwNetdTknfzSkVTpFcPSGZww@mail.gmail.com>
	 <1392882819.5070.15.camel@x220> <878usz8vmi.fsf@intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-1.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 04 Mar 2014 08:31:21.0825 (UTC) FILETIME=[1F5A3510:01CF3784]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2014-02-25 at 10:05 +0200, Jani Nikula wrote:
> On Thu, 20 Feb 2014, Paul Bolle <pebolle@tiscali.nl> wrote:
> > On an (rather old) ThinkPad X41, which also uses i915, brightness
> > adjustments stopped working altogether in v3.14-rc1 (I haven't used its
> > docking station in the v3.14 release cycle). In v3.13.y things behave as
> > expected. So perhaps there's actually a more general problem here.
> 
> I presume different problems. Does the ThinkPad X41 have gen3 graphics?
> (See e.g. /sys/kernel/debug/dri/0/i915_capabilities) If yes, it might be
> https://bugs.freedesktop.org/show_bug.cgi?id=75001

Yes, it has "gen3" graphics (a 915GM). And applying your patch
"drm/i915: use backlight legacy combination mode also for
i915gm/i945/gm" on top of v3.14-rc5 fixes the issue on that ThinkPad
X41.

Thanks,


Paul Bolle

