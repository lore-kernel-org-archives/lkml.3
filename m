Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757084Ab3EGJxC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 05:53:02 -0400
Received: from mga09.intel.com ([134.134.136.24]:17336 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756966Ab3EGJw7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 05:52:59 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,627,1363158000"; 
   d="scan'208";a="309468786"
Date: Tue, 7 May 2013 11:52:38 +0200
From: Samuel Ortiz <sameo@linux.intel.com>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Robin Holt <holt@sgi.com>, Qing Xu <qingx@marvell.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: How does commit 47ec340c not introduce a bug?
Message-ID: <20130507095238.GA4387@zurbaran>
References: <20130507091734.GM3658@sgi.com>
 <20130507092428.GK23285@pengutronix.de>
 <CAN1soZyHx1XZzukunbKsj+v4h93MRQKjPPjJ3+i3u8BeBbhCGw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAN1soZyHx1XZzukunbKsj+v4h93MRQKjPPjJ3+i3u8BeBbhCGw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 07, 2013 at 05:35:28PM +0800, Haojian Zhuang wrote:
> > It's probably best to make this:
> >
> > static inline max8925_backlight_dt_init(struct platform_device *pdev,
> >                                 struct max8925_backlight_pdata *pdata)
> > {
> >         return -ENODEV;
> > }
> >
> 
> I've submitted this patch to fix this issue for a long time.
> 
> Samuel,
> 
> Should I send it again?
To the backlight maintainers, yes. I carried 47ec340c as it was part of an MFD
patchset, but now that it's upstream I shouldn't take any patches for it.

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
