Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753371Ab3A1T2O (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:28:14 -0500
Received: from mail-qa0-f47.google.com ([209.85.216.47]:60729 "EHLO
	mail-qa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751977Ab3A1T2M (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:28:12 -0500
Date: Mon, 28 Jan 2013 11:28:07 -0800
From: Tejun Heo <tj@kernel.org>
To: Sedat Dilek <sedat.dilek@gmail.com>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linux PM List <linux-pm@lists.linux-foundation.org>,
        Linux ACPI <linux-acpi@vger.kernel.org>,
        Sasha Levin <sasha.levin@oracle.com>
Subject: Re: linux-next: Tree for Jan 25 (BROKEN suspend)
Message-ID: <20130128192807.GF22465@mtj.dyndns.org>
References: <CA+icZUW6LBSjpqK-eQUAt7R=kXCPRjFoi=z1UijaajrVAj=fEg@mail.gmail.com>
 <CA+icZUX=XdAJjWwx8P_y31JGW3GC+tdWuFhv2Ym-0OELGWGbDQ@mail.gmail.com>
 <CA+icZUX31SB3+NU8uXA9LH5KOHxgeHKZLcqWNhzUVhx5onk6qA@mail.gmail.com>
 <18624541.r6CtJttOWZ@vostro.rjw.lan>
 <CA+icZUX+o6kB9wXwpuJ8U49j+qHdx=DRq7p+_U1g+1fwGb-S6w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+icZUX+o6kB9wXwpuJ8U49j+qHdx=DRq7p+_U1g+1fwGb-S6w@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, guys.

On Sun, Jan 27, 2013 at 02:01:50PM +0100, Sedat Dilek wrote:
> OK, that bisecting ruined a bit my weekend and showed me again you
> cannot really bisect Linux-Next.
> Sometimes, it is better not to trust the tools blindly and do a
> bisect-on-suspicion.
> Anyway... cultprit found... patch found... applied... all GOOD now.
> ( If I had waited for next Monday's next-20130127 I would not have
> seen what caused the trouble. ).

Yeah, my usual test setup didn't have async tasks w/o domain so I
failed to notice the breakage.  Sorry about the trouble guys and lots
of thanks to Sedat for the firefighting over the weekend.  :)

-- 
tejun
