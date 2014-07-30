Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752065AbaG3WnE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jul 2014 18:43:04 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:43924 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253AbaG3WnB convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jul 2014 18:43:01 -0400
Content-Type: text/plain; charset="utf-8"
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
To: Tero Kristo <t-kristo@ti.com>, "Peter Ujfalusi" <peter.ujfalusi@ti.com>
From: Mike Turquette <mturquette@linaro.org>
In-Reply-To: <53D8E49B.3040600@ti.com>
Cc: "Tony Lindgren" <tony@atomide.com>,
        "Linux OMAP Mailing List" <linux-omap@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
References: <1396446525-20302-1-git-send-email-peter.ujfalusi@ti.com>
 <5358D534.2070205@ti.com> <535927DF.90404@ti.com> <5368E604.4040107@ti.com>
 <53C3AC94.5050904@ti.com> <20140729062748.4906.1529@quantum>
 <53D759E6.3060607@ti.com>
 <CAPtuhTjMAZcHecO0dr+3zDurCfQH32pmYUQ+zNXhRdS_+vJZsg@mail.gmail.com>
 <53D8886A.5020600@ti.com> <53D8E49B.3040600@ti.com>
Message-ID: <20140730224257.11617.85064@quantum>
User-Agent: alot/0.3.5
Subject: Re: [PATCH] clk: ti: clk-7xx: Correct ABE DPLL configuration
Date: Wed, 30 Jul 2014 15:42:57 -0700
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Quoting Tero Kristo (2014-07-30 05:27:07)
> On 07/30/2014 08:53 AM, Peter Ujfalusi wrote:
> > On 07/29/2014 07:12 PM, Mike Turquette wrote:
> >>> Oh yea, seems this got lost into the myriad of branches I have. I can push
> >>> this on top of my for-v3.17/ti-clk-drv if you like.
> >>
> >> That is the easiest thing for me. I think that Peter wanted to take
> >> this as a fix for 3.16 though. Peter is that correct?
> >
> > Yes, it would have been better to have it in 3.16 along with the DRA7 ATL
> > clock driver. W/O this patch the ATL will not going to be usable since the ABE
> > DPLL is set too high to be usable for it's purpose.
> >
> 
> Ok, this is now pushed on top of the for-v3.17/ti-clk-driver branch in 
> my git-repo. Mike, do you want a new pull-req for this just in case?

I've picked it manually and applied on top of 3.16-rc7 for a last minute
fix. I can add your Ack if you like.

Regards,
Mike

> 
> -Tero
