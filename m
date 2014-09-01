Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752854AbaIAXiX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 19:38:23 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:42284 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751952AbaIAXiV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 19:38:21 -0400
Date: Tue, 2 Sep 2014 08:38:14 +0900
From: Simon Horman <horms@verge.net.au>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Magnus Damm <magnus.damm@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] v4l: vsp1: fix driver dependencies
Message-ID: <20140901233814.GA15867@verge.net.au>
References: <25174054.f3JtKIKjvH@amdc1032>
 <CAMuHMdX3UX-XL8g1qQ-aJeRy_iT1uUvcGHyWF2gci+rnPZx4BA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMuHMdX3UX-XL8g1qQ-aJeRy_iT1uUvcGHyWF2gci+rnPZx4BA@mail.gmail.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 01, 2014 at 06:32:56PM +0200, Geert Uytterhoeven wrote:
> On Mon, Sep 1, 2014 at 3:18 PM, Bartlomiej Zolnierkiewicz
> <b.zolnierkie@samsung.com> wrote:
> > Renesas VSP1 Video Processing Engine support should be available
> > only on Renesas ARM SoCs.
> 
> Thanks!
> 
> > Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
> > Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> > Cc: Simon Horman <horms@verge.net.au>
> > Cc: Magnus Damm <magnus.damm@gmail.com>
> 
> Acked-by: Geert Uytterhoeven <geert+renesas@glider.be>

Acked-by: Simon Horman <horms+renesas@verge.net.au>
