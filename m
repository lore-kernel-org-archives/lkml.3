Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753957Ab3L0A0Q (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Dec 2013 19:26:16 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:55902 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751256Ab3L0A0O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Dec 2013 19:26:14 -0500
Date: Thu, 26 Dec 2013 16:26:12 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
To: Felipe Balbi <balbi@ti.com>, David Brown <davidb@codeaurora.org>
Cc: "Ivan T. Ivanov" <iivanov@mm-sol.com>, gregkh@linuxfoundation.org,
        rob.herring@calxeda.com, pawel.moll@arm.com, mark.rutland@arm.com,
        swarren@wwwdotorg.org, ijc+devicetree@hellion.org.uk,
        linux-usb@vger.kernel.org, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4 00/15]  usb: phy: msm: Fixes, cleanups and DT support
Message-ID: <20131227002612.GA14405@codeaurora.org>
References: <1384267910-32066-1-git-send-email-iivanov@mm-sol.com>
 <20131126163846.GF24310@saruman.home>
 <20131219230315.GA20875@codeaurora.org>
 <20131219232613.GH707@saruman.home>
 <20131220195932.GA25667@codeaurora.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131220195932.GA25667@codeaurora.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20, David Brown wrote:
> On Thu, Dec 19, 2013 at 05:26:13PM -0600, Felipe Balbi wrote:
> 
> >it's getting quite late for me. I still want to leave my stuff soaking
> >in linux-next for a while. I'll try my best, though, if you ack it ASAP
> 
> Thanks.  Patch 1 already has my Ack in it, and I've sent an ack for
> number 6.
> 

Felipe,

If this isn't picked up for 3.14 can we get an ack on patch 1 so
we can send it through arm-soc as part of the multi-platform
patches I have for MSM[1]?

[1] https://lkml.org/lkml/2013/12/4/523
-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation
