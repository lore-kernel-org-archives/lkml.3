Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754453Ab3HBC3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 22:29:31 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:38053 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751400Ab3HBC33 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 22:29:29 -0400
Message-ID: <51FB1987.3060806@wwwdotorg.org>
Date: Thu, 01 Aug 2013 20:29:27 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Rohit Vaswani <rvaswani@codeaurora.org>
CC: David Brown <davidb@codeaurora.org>, Rob Herring <rob.herring@calxeda.com>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ian.campbell@citrix.com>,
        Russell King <linux@arm.linux.org.uk>,
        Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>, devicetree@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org
Subject: Re: [RESEND PATCH 1/2] ARM: msm: Add support for MSM8974
References: <1375406619-14618-1-git-send-email-rvaswani@codeaurora.org>
In-Reply-To: <1375406619-14618-1-git-send-email-rvaswani@codeaurora.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/01/2013 07:23 PM, Rohit Vaswani wrote:
> This patch adds basic board support for MSM8974 which
> belongs to the Snapdragon 800 family.
> For now, just support a basic machine with device tree.

>  arch/arm/boot/dts/msm8974.dts     | 26 ++++++++++++++++++++++++++

That's odd. If this is support for an SoC, why not a *.dtsi file rather
than *.dts?
