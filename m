Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaJ0AYO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Oct 2014 20:24:14 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:34930 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751754AbaJ0AYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Oct 2014 20:24:12 -0400
Date: Mon, 27 Oct 2014 09:24:03 +0900
From: Simon Horman <horms@verge.net.au>
To: Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>, linux-sh@vger.kernel.org,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        Magnus Damm <magnus.damm@gmail.com>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3] clocksource: sh_tmu: Document R-Mobile r8a7740
 binding
Message-ID: <20141027002402.GB32437@verge.net.au>
References: <1413970709-26607-1-git-send-email-geert+renesas@glider.be>
 <1413970709-26607-2-git-send-email-geert+renesas@glider.be>
 <6890235.hnMLlLN6KA@avalon>
 <20141024023451.GE7537@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141024023451.GE7537@verge.net.au>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 24, 2014 at 11:34:55AM +0900, Simon Horman wrote:
> On Wed, Oct 22, 2014 at 05:59:25PM +0300, Laurent Pinchart wrote:
> > Hi Geert,
> > 
> > Thank you for the patch.
> > 
> > On Wednesday 22 October 2014 11:38:27 Geert Uytterhoeven wrote:
> > > Compared to the r8a7779, the r8a7740 lacks the input capture register,
> > > which is not used by the driver (the current driver already handles the
> > > r8a7740 in the non-DT case).
> > > 
> > > Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> > 
> > Acked-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> 
> Acked-by: Simon Horman <horms+renesas@verge.net.au>

It seems that I have committed the last few changes to this file,
so I've queued up this one too.
