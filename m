Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756503Ab3A1LRY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:17:24 -0500
Received: from www262.sakura.ne.jp ([202.181.97.72]:56133 "EHLO
	www262.sakura.ne.jp" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754144Ab3A1LRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:17:21 -0500
X-Nat-Received: from [202.181.97.72]:62416 [ident-empty]
	by smtp-proxy.isp with TPROXY id 1359371800.18904
To: linus.walleij@linaro.org
Cc: rob.herring@calxeda.com, grant.likely@secretlab.ca,
        rmk+kernel@arm.linux.org.uk, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
Subject: Re: [PATCH v2] ARM: versatile: fix the PCI IRQ regression
From: Tetsuo Handa <penguin-kernel@I-love.SAKURA.ne.jp>
References: <1359328750-28046-1-git-send-email-linus.walleij@linaro.org>
In-Reply-To: <1359328750-28046-1-git-send-email-linus.walleij@linaro.org>
Message-Id: <201301282016.BAG95395.VMOFFFQSHLOtJO@I-love.SAKURA.ne.jp>
X-Mailer: Winbiff [Version 2.51 PL2]
X-Accept-Language: ja,en,zh
Date: Mon, 28 Jan 2013 20:16:35 +0900
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.45.2/RELEASE, bases: 28012013 #9523468, status: clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus Walleij wrote:
> ---
> ChangeLog v1->v2:
> - Got the PIC/SIC valid mask wrong again, take a deep breath
>   and use the foolproof method of defining each bit so that
>   nobody will get caught by this again. Didn't see this first
>   because the SCSI layer takes for ever to time out.
> ---
>  arch/arm/mach-versatile/core.c | 15 ++++++++++++++-
>  arch/arm/mach-versatile/pci.c  | 11 ++++++-----
>  2 files changed, 20 insertions(+), 6 deletions(-)
> 

This patch fixes my problem. Please send to 3.8. Thank you!
