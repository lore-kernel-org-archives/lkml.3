Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755425Ab3LTR0M (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 12:26:12 -0500
Received: from smtp.codeaurora.org ([198.145.11.231]:57097 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753726Ab3LTR0K convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 12:26:10 -0500
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 7.0 \(1822\))
Subject: Re: [PATCH 1/2] of: add vendor prefix for Mentor Graphics
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1387470351-4696-1-git-send-email-bigeasy@linutronix.de>
Date: Fri, 20 Dec 2013 11:26:02 -0600
Cc: linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Felipe Balbi <balbi@ti.com>, devicetree <devicetree@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Rob Landley <rob@landley.net>
Content-Transfer-Encoding: 8BIT
Message-Id: <D53158FF-7BCF-4BA8-A589-B6365B4DA058@codeaurora.org>
References: <1387470351-4696-1-git-send-email-bigeasy@linutronix.de>
To: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
X-Mailer: Apple Mail (2.1822)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Dec 19, 2013, at 10:25 AM, Sebastian Andrzej Siewior <bigeasy@linutronix.de> wrote:

> This prefix is currently used for the musb driver.
> 
> Acked-by: Stephen Warren <swarren@nvidia.com>
> Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
> ---
> Documentation/devicetree/bindings/vendor-prefixes.txt | 1 +
> 1 file changed, 1 insertion(+)
> 
> diff --git a/Documentation/devicetree/bindings/vendor-prefixes.txt b/Documentation/devicetree/bindings/vendor-prefixes.txt
> index 8c75d85..cb5c438 100644
> --- a/Documentation/devicetree/bindings/vendor-prefixes.txt
> +++ b/Documentation/devicetree/bindings/vendor-prefixes.txt
> @@ -43,6 +43,7 @@ linux	Linux-specific binding
> lsi	LSI Corp. (LSI Logic)
> marvell	Marvell Technology Group Ltd.
> maxim	Maxim Integrated Products
> +mentor	Mentor Graphics

file like we should use ‘ment’, but not sure if we are going away from ticker symbols or not.

> microchip	Microchip Technology Inc.
> mosaixtech	Mosaix Technologies, Inc.
> national	National Semiconductor
> -- 
> 1.8.5.1
> 

- k

-- 
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

