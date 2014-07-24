Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934095AbaGXEOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jul 2014 00:14:15 -0400
Received: from mail-out.m-online.net ([212.18.0.10]:34700 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933818AbaGXEOO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jul 2014 00:14:14 -0400
X-Auth-Info: EHvjegFZnBBTMlgA4UCAjaJTaWo13fri8PYnGvuLvcc=
From: Marek Vasut <marex@denx.de>
To: Yao Yuan <yao.yuan@freescale.com>
Subject: Re: [PATCH v4 1/2] i2c: add DMA support for freescale i2c driver
Date: Thu, 24 Jul 2014 06:14:11 +0200
User-Agent: KMail/1.13.7 (Linux/3.13-trunk-amd64; KDE/4.13.1; x86_64; ; )
Cc: Wolfram Sang <wsa@the-dreams.de>,
        "mark.rutland@arm.com" <mark.rutland@arm.com>,
        "shawn.guo@linaro.org" <shawn.guo@linaro.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-i2c@vger.kernel.org" <linux-i2c@vger.kernel.org>
References: <1396579272-19542-1-git-send-email-yao.yuan@freescale.com> <20140521080047.GC2708@katana> <e97f086de6e9427f96ca5ac582031f86@BL2PR03MB338.namprd03.prod.outlook.com>
In-Reply-To: <e97f086de6e9427f96ca5ac582031f86@BL2PR03MB338.namprd03.prod.outlook.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="us-ascii"
Content-Transfer-Encoding: 7bit
Message-Id: <201407240614.11878.marex@denx.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, July 24, 2014 at 05:19:27 AM, Yao Yuan wrote:
> On Fri, May 21, 2014 at 4:01 PM +0200, Wolfram Sang wrote:
> > Ping. Any updates? I think this was pretty close to inclusion?
> 
> Hi, Wolfram
> 	Thanks for your concern. Sorry for my reply so late. I had on a business
> trip for months. At that time I have no device to debug it. Now, I'm come
> back and I will try my best to finish it. I have sent the patch for V5.
> Thanks for your review.

So you have no means to test this ? Can this be tested on MX5 ? MX6 ?

Best regards,
Marek Vasut
