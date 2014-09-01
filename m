Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581AbaIAAzx (ORCPT <rfc822;w@1wt.eu>);
	Sun, 31 Aug 2014 20:55:53 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:44889 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752144AbaIAAzs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 31 Aug 2014 20:55:48 -0400
Date: Mon, 1 Sep 2014 09:55:45 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Magnus Damm <magnus.damm@gmail.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] ARM: dts: Add shmobile platform device tree bindings
 documentation
Message-ID: <20140901005544.GB28783@verge.net.au>
References: <1409213120-5291-1-git-send-email-geert+renesas@glider.be>
 <20140829003456.GM16165@verge.net.au>
 <CAMuHMdXNPk2ACbFsXcPic_zZBDCjF+5j6-jQNgZxGePPcTRUBQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdXNPk2ACbFsXcPic_zZBDCjF+5j6-jQNgZxGePPcTRUBQ@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 10:26:01AM +0200, Geert Uytterhoeven wrote:
> Hi Simon,
> 
> On Fri, Aug 29, 2014 at 2:34 AM, Simon Horman <horms@verge.net.au> wrote:
> > On Thu, Aug 28, 2014 at 10:05:20AM +0200, Geert Uytterhoeven wrote:
> >> Add Renesas SH-Mobile, R-Mobile, and R-Car Platform Device Tree Bindings
> >> Documentation, listing supported SoCs and boards.
> >>
> >> This allows to use checkpatch to validate DTSes referring to Renesas
> >> shmobile SoCs, and boards containing those SoCs.
> >>
> >> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> >
> > Thanks Geert, this looks good to me.
> > Is it for me to pick up?
> 
> I think so.
> 
> > If so I would prefer a slightly re-structured title:
> >
> > ARM: shmobile: Add platform device tree bindings documentation
> 
> Fine for me.
> 
> Do you want me to resend, or will you amend yourself?

No need to resend at this time :)
