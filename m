Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933684Ab3GPSjn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 14:39:43 -0400
Received: from 1wt.eu ([62.212.114.60]:34726 "EHLO 1wt.eu"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933441Ab3GPSjl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 14:39:41 -0400
Date: Tue, 16 Jul 2013 20:39:27 +0200
From: Willy Tarreau <w@1wt.eu>
To: Takashi Iwai <tiwai@suse.de>
Cc: David Lang <david@lang.hm>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        ksummit-2013-discuss@lists.linux-foundation.org,
        torvalds@linux-foundation.org
Subject: Re: [Ksummit-2013-discuss] When to push bug fixes to mainline
Message-ID: <20130716183927.GH15902@1wt.eu>
References: <20130711214830.611455274@linuxfoundation.org> <20130712005023.GB31005@thunk.org> <20130712051451.GC25815@1wt.eu> <alpine.DEB.2.02.1307160017120.16723@nftneq.ynat.uz> <s5hwqoqv4oo.wl%tiwai@suse.de>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <s5hwqoqv4oo.wl%tiwai@suse.de>
User-Agent: Mutt/1.4.2.3i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Takashi,

On Tue, Jul 16, 2013 at 06:40:39PM +0200, Takashi Iwai wrote:
> IMO, one of the reasons is the nature of stable-release: the stable
> tree is released soon after reviews of patches, so no actual
> regression tests can be done before the release.
> 
> For finding a regression, patch reviews won't be enough; all patches
> have been already reviewed, thus essentially they must be all
> positive/good fixes.  And the compile is OK.  So what's the problem?
> 
> Maybe some QA period before the release might help, but who would
> care?  (Especially under the situation where everybody has own x.y
> stable tree?)

Almost nobody *tests* the previews. Except the few regular testers, but
they test in a finite environment so there is very little coverage in
the end. I'm not dismissing their work, because without them we'd have
zero testers. I'd prefer to have more than we currently have. But it's
also almost impossible to test reviews on servers, so a wide category
of fixes is probably never tested anyway during previews (eg: RAID
cards, or fixes for bugs affecting large amounts of memory/disk/cpus).

What makes the success of -stable is that Greg is able to re-release
very quickly when a bug is reported, sometimes even the same day. It's
something I'm totally incapable of, not having enough contiguous spare
time to work regularly enough on releases. That's the real key to
success. As a user, I look at the changes between versions and generally
only upgrade if something seems to be hitting me. That way I need less
updates and skip more regressions. And I'm sure most users do the same.

Regards,
Willy

