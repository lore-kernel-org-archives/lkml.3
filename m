Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552Ab3JCCaG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Oct 2013 22:30:06 -0400
Received: from kirsty.vergenet.net ([202.4.237.240]:39834 "EHLO
	kirsty.vergenet.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753001Ab3JCCaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Oct 2013 22:30:04 -0400
Date: Thu, 3 Oct 2013 11:30:00 +0900
From: Simon Horman <horms@verge.net.au>
To: Daniel Lezcano <daniel.lezcano@linaro.org>,
        Laurent Pinchart <laurent.pinchart@ideasonboard.com>
Cc: takasi-y@ops.dti.ne.jp, SH-Linux <linux-sh@vger.kernel.org>,
        Magnus Damm <magnus.damm@gmail.com>, ben.dooks@codethink.co.uk,
        Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>,
        devicetree@vger.kernel.org, linux-serial@vger.kernel.org,
        Paul Mundt <lethal@linux-sh.org>,
        Mike Turquette <mturquette@linaro.org>, linux-kernel@vger.kernel.org,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [PATCH 1/6] clocksource: em_sti: convert to clk_prepare/unprepare
Message-ID: <20131003023000.GA27371@verge.net.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1504961.3u9y73MgII@avalon>
 <52440A07.4050101@linaro.org>
Organisation: Horms Solutions Ltd.
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Sep 26, 2013 at 12:18:47PM +0200, Daniel Lezcano wrote:
> On 09/24/2013 06:42 AM, Simon Horman wrote:
> >[ CCed Daniel Lezcano and Thomas Gleixner, the clocksource maintainers ]
> >
> >On Tue, Sep 24, 2013 at 01:09:24PM +0900, takasi-y@ops.dti.ne.jp wrote:
> >>From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> >>
> >>Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> >>migrate to the common clock framework.
> >>
> >>Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> 
> I am not a clk framework expert but at the first glance sounds correct.
> 
> Acked-by: Daniel Lezcano <daniel.lezcano@linaro.org>

On Mon, Sep 30, 2013 at 05:25:41PM +0200, Laurent Pinchart wrote:
> Hi Yoshii-san,
> 
> Thank you for the patch.
> 
> On Tuesday 24 September 2013 13:09:24 takasi-y@ops.dti.ne.jp wrote:
> > From: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> > 
> > Add calls to clk_prepare and unprepare so that EMMA Mobile EV2 can
> > migrate to the common clock framework.
> > 
> > Signed-off-by: Shinya Kuribayashi <shinya.kuribayashi.px@renesas.com>
> 
> Acked-by: Laurent Pinchart <laurent.pinchart@ideasonboard.com>

Thanks, I have queued this up in the clocksource branch of the renesas
tree. I'll send a pull request to Daniel in the not to distant future.
