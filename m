Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753693Ab3JCCar (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 22:30:47 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39851 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3JCCap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 22:30:45 -0400
Date: Thu, 3 Oct 2013 11:30:42 +0900
From: Simon Horman <horms@verge.net.au>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: takasi-y@ops.dti.ne.jp, SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/6] serial8250-em: convert to clk_prepare/unprepare
Message-ID: <20131003023042.GB27371@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <4895580.Leadr2OAf1@avalon>
 <20130924134113.GA7246@kroah.com>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 06:41:13AM -0700, Greg Kroah-Hartman wrote:
> On Tue, Sep 24, 2013 at 01:44:32PM +0900, Simon Horman wrote:
> > [ CCed Greg Kroah-Hartman, the serial maintainer for his review ]
> > 
> > On Tue, Sep 24, 2013 at 01:10:39PM +0900, takasi-y@ops.dti.ne.jp wrote:
> > > From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> > > 
> > > Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> > > migrate to the common clock framework.
> > > 
> > > Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> > > [takashi.yoshii.ze@renesas.com: edited for conflicts]
> > > Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> 
> Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 

On Mon, Sep 30, 2013 at 05:25:40PM +0200, Laurent Pinchart wrote:
> Hi Yoshii-san,
> 
> Thank you for the patch.
> 
> On Tuesday 24 September 2013 13:10:39 takasi-y@ops.dti.ne.jp wrote:
> > From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> > 
> > Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> > migrate to the common clock framework.
> > 
> > Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> > [takashi.yoshii.ze@renesas.com: edited for conflicts]
> > Signed-off-by: Takashi Yoshii <takashi.yoshii.zj@renesas.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks, I have queued this up in the serial branch of the renesas tree.
