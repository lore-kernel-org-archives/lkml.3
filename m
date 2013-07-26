Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757560Ab3GZRs0 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Jul 2013 13:48:26 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:46390 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754Ab3GZRsX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Jul 2013 13:48:23 -0400
Subject: Re: [PATCH 1/4] ARM: msm: Remove pen_release usage
Mime-Version: 1.0 (Apple Message framework v1283)
Content-Type: text/plain; charset=us-ascii
From: Kumar Gala <galak@codeaurora.org>
In-Reply-To: <1372461962-17197-2-git-send-email-rvaswani@codeaurora.org>
Date: Fri, 26 Jul 2013 12:48:24 -0500
Cc: David Brown <davidb@codeaurora.org>, Daniel Walker <dwalker@fifo99.com>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Russell King <linux@arm.linux.org.uk>, linux-arm-msm@vger.kernel.org,
        linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8BIT
Message-Id: <6FE2B9F1-31C1-410A-93BE-9EFA2C6795C0@codeaurora.org>
References: <1372461962-17197-1-git-send-email-rvaswani@codeaurora.org> <1372461962-17197-2-git-send-email-rvaswani@codeaurora.org>
To: Rohit Vaswani <rvaswani@codeaurora.org>
X-Mailer: Apple Mail (2.1283)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On Jun 28, 2013, at 6:25 PM, Rohit Vaswani wrote:

> pen_release is no longer required as the synchronization
> is now managed by generic arm code.
> This is done as suggested in https://lkml.org/lkml/2013/6/4/184
> 
> Signed-off-by: Rohit Vaswani <rvaswani@codeaurora.org>
> ---
> arch/arm/mach-msm/headsmp.S | 41 -----------------------------------------
> arch/arm/mach-msm/hotplug.c | 31 ++++---------------------------
> arch/arm/mach-msm/platsmp.c | 35 +++--------------------------------
> 3 files changed, 7 insertions(+), 100 deletions(-)
> delete mode 100644 arch/arm/mach-msm/headsmp.S

Don't you need to update arch/arm/mach-msm/Makefile to remove headsmp.o from:

obj-$(CONFIG_SMP) += headsmp.o platsmp.o

- k

--
Employee of Qualcomm Innovation Center, Inc.
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum, hosted by The Linux Foundation

