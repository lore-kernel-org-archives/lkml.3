Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754820AbbATR0l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 12:26:41 -0500
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:52275 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751849AbbATR0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 12:26:40 -0500
Message-ID: <1421774797.29393.4.camel@x220>
Subject: Re: [PATCH net-next v8 2/4] net: netcp: Add Keystone NetCP core
 ethernet driver
From: Paul Bolle <pebolle@tiscali.nl>
To: Murali Karicheri <m-karicheri2@ti.com>
Cc: Wingman Kwok <w-kwok2@ti.com>,
        Valentin Rothberg <valentinrothberg@gmail.com>, davem@davemloft.net,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        netdev@vger.kernel.org
Date: Tue, 20 Jan 2015 18:26:37 +0100
In-Reply-To: <54BE8BEA.3000100@ti.com>
References: <1421367172-19793-1-git-send-email-m-karicheri2@ti.com>
	  <1421367172-19793-2-git-send-email-m-karicheri2@ti.com>
	 <1421741935.9655.73.camel@x220> <54BE8BEA.3000100@ti.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-4.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 20 Jan 2015 17:26:37.0840 (UTC) FILETIME=[3F00B100:01D034D6]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 12:10 -0500, Murali Karicheri wrote:
> On 01/20/2015 03:18 AM, Paul Bolle wrote:
> > On Thu, 2015-01-15 at 19:12 -0500, Murali Karicheri wrote:
> >> diff --git a/drivers/net/ethernet/ti/Kconfig b/drivers/net/ethernet/ti/Kconfig
> >> index 605dd90..e11bcfa 100644
> >> --- a/drivers/net/ethernet/ti/Kconfig
> >> +++ b/drivers/net/ethernet/ti/Kconfig
> >> @@ -73,12 +73,23 @@ config TI_CPSW
> >>   config TI_CPTS
> >>   	boolean "TI Common Platform Time Sync (CPTS) Support"
> >>   	depends on TI_CPSW
> >> +	depends on TI_CPSW || TI_KEYSTONE_NET
> >
> > You probably meant to add
> >      || TI_KEYSTONE_NETCP
> >
> > here. Ie, add CP. But as this slipped through testing it _might_ not be
> > needed at all.
> 
> Currently CPTS driver is not used for NetCP. So I want to remove the 
> above Kconfig dependency from Kconfig and cpts.o from the Makefile. Do 
> you expect me to send an incremental patch for this to the netdev list? 

That's Dave's call. I think that Dave works with incremental patches
exclusively once things have hit (one of the trees that feed into)
linux-next.

> or can pick the attached patch that addresses this issue. Let me know.

I'm just the reporter. Please send it through the regular channels. That
would certainly include netdev.


Paul Bolle

