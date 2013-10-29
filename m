Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753010Ab3J2UPs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 16:15:48 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:38374 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751380Ab3J2UPq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 16:15:46 -0400
Date: Tue, 29 Oct 2013 13:15:45 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Josh Cartwright <joshc@codeaurora.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        David Brown <davidb@codeaurora.org>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-arm-msm@vger.kernel.org,
        rtc-linux@googlegroups.com, Sagar Dharia <sdharia@codeaurora.org>,
        Gilad Avidov <gavidov@codeaurora.org>,
        Michael Bohan <mbohan@codeaurora.org>
Subject: Re: [PATCH v3 10/10] rtc: pm8xxx: add support for pm8941
Message-ID: <20131029201545.GA2064@kroah.com>
References: <cover.1382985169.git.joshc@codeaurora.org>
 <1392ea90487793f9cbbdfb7f8d148f45122a52c2.1382985169.git.joshc@codeaurora.org>
 <20131029200927.GG21983@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131029200927.GG21983@codeaurora.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 01:09:27PM -0700, Stephen Boyd wrote:
> On 10/28, Josh Cartwright wrote:
> > diff --git a/drivers/rtc/rtc-pm8xxx.c b/drivers/rtc/rtc-pm8xxx.c
> > index 03f8f75..a9044d4 100644
> > --- a/drivers/rtc/rtc-pm8xxx.c
> > +++ b/drivers/rtc/rtc-pm8xxx.c
> > @@ -1,4 +1,5 @@
> >  /* Copyright (c) 2010-2011, Code Aurora Forum. All rights reserved.
> > + * Copyright (c) 2013, The Linux Foundation. All rights reserved.
> >   *
> 
> Please rewrite this as '2010-2011,2013, The Linux Foundation'

Has the Linux Foundation really taken on all prior copyrights of this
codebase?  CAF wasn't around in 2010 as part of the LF, so be careful
here.

greg k-h
