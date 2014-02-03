Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750965AbaBCI6J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:58:09 -0500
Received: from ns1.pc-advies.be ([83.149.101.17]:55745 "EHLO
	spo001.leaseweb.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750750AbaBCI6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:58:08 -0500
Date: Mon, 3 Feb 2014 09:58:00 +0100
From: Wim Van Sebroeck <wim@iguana.be>
To: Richard Weinberger <richard@nod.at>
Cc: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] watchdog,dw: Add dependency on HAS_IOMEM
Message-ID: <20140203085800.GC29278@spo001.leaseweb.com>
References: <1391172454-17959-1-git-send-email-richard@nod.at>
Mime-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1391172454-17959-1-git-send-email-richard@nod.at>
User-Agent: Mutt/1.4.1i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Richard,

> On archs like S390 or um this driver cannot build nor work.
> Make it depend on HAS_IOMEM to bypass build failures.
> 
> drivers/built-in.o: In function `dw_wdt_drv_probe':
> drivers/watchdog/dw_wdt.c:302: undefined reference to `devm_ioremap_resource'
> 
> Signed-off-by: Richard Weinberger <richard@nod.at>

Patch added to linux-watchdog-next.

Kind regards,
Wim.

