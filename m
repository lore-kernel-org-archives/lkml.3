Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3BEV4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:56:02 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:47646 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756960Ab3BEVz6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:55:58 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Jesse Barnes <jbarnes@virtuousgeek.org>
Cc: linux-kernel@vger.kernel.org, intel-gfx@lists.freedesktop.org,
        linux-pm@vger.kernel.org
Subject: Re: [PATCH 1/3] PM: make VT switching to the suspend console optional v3
Date: Tue, 05 Feb 2013 23:02:17 +0100
Message-ID: <2155667.rslrpFmW0n@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc6; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130205135544.6adab270@jbarnes-t420>
References: <1359985042-2610-1-git-send-email-jbarnes@virtuousgeek.org> <1452100.EKe1it2LWl@vostro.rjw.lan> <20130205135544.6adab270@jbarnes-t420>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, February 05, 2013 01:55:44 PM Jesse Barnes wrote:
> On Mon, 04 Feb 2013 21:26:26 +0100
> "Rafael J. Wysocki" <rjw@sisk.pl> wrote:
> 
> > On Monday, February 04, 2013 01:37:20 PM Jesse Barnes wrote:
> > > KMS drivers can potentially restore the display configuration without
> > > userspace help.  Such drivers can can call a new funciton,
> > > pm_vt_switch_required(false) if they support this feature.  In that
> > > case, the PM layer won't VT switch to the suspend console at suspend
> > > time and then back to the original VT on resume, but rather leave things
> > > alone for a nicer looking suspend and resume sequence.
> > > 
> > > v2: make a function so we can handle multiple drivers (Alan)
> > > v3: use a list to track device requests (Rafael)
> > > 
> > > Signed-off-by: Jesse Barnes <jbarnes@virtuousgeek.org>
> > 
> > Acked-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
> > 
> > for all [1-3/3].
> 
> Any chance for an r-b on the PM one at least?  Then Daniel could
> probably push this through drm-intel-next.

Done.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
