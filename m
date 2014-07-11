Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754427AbaGKPJh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 11:09:37 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42323 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751644AbaGKPJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 11:09:35 -0400
Date: Fri, 11 Jul 2014 17:09:22 +0200
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH 10/13] [RFC] ARM: dts: Add shmobile platform device tree
 bindings documentation
Message-ID: <20140711150921.GA1777@verge.net.au>
References: <1404908623-909-1-git-send-email-geert+renesas@glider.be>
 <1404908623-909-11-git-send-email-geert+renesas@glider.be>
 <20140711091720.GO12420@verge.net.au>
 <CAMuHMdXP6GfO7OEnXU8x4Sn5j8_tA2nnrFANr1sriB-B4BYoOQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXP6GfO7OEnXU8x4Sn5j8_tA2nnrFANr1sriB-B4BYoOQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 11, 2014 at 04:26:03PM +0200, Geert Uytterhoeven wrote:
> Hi Simon,
> 
> On Fri, Jul 11, 2014 at 11:17 AM, Simon Horman <horms@verge.net.au> wrote:
> > On Wed, Jul 09, 2014 at 02:23:40PM +0200, Geert Uytterhoeven wrote:
> >> Add Renesas SH-Mobile, R-Mobile, and R-Car Platform Device Tree Bindings
> >> Documentation, listing supported SoCs and boards.
> >>
> >> This allows to use checkpatch to validate DTSes referring to Renesas
> >> shmobile SoCs, and boards containing those SoCs.
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >> Cc: linux-arm-kernel@lists.infradead.org
> >
> > Thanks Geert,
> >
> > from my point of view this seems nice. Is there a reason it is marked as an RFC?
> 
> >From the cover letter:
> 
> "The last 4 patches contain compatible strings for new R-Car Gen2 SoCs,
>  which are not yet in active use, hence the RFC status."

Thanks, sorry for missing that.
