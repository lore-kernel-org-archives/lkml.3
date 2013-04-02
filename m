Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762021Ab3DBRyd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 13:54:33 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:59138 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759028Ab3DBRy2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 13:54:28 -0400
Date: Tue, 2 Apr 2013 10:48:01 -0700
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Marc Zyngier <marc.zyngier@arm.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL v2] at91: soc for 3.10 #2
Message-ID: <20130402174801.GI25867@quad.lixom.net>
References: <5152B357.3020500@atmel.com>
 <1364467109-11173-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1364467109-11173-1-git-send-email-nicolas.ferre@atmel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 28, 2013 at 11:38:29AM +0100, Nicolas Ferre wrote:
> Arnd, Olof,
> 
> A pull-request for 3.10 that is dedicated to the introduction of
> Atmel's new Cortex-A5 based product: SAMA5D3.
> This tag is built on top of the material already provided that resides on your
> side in at91/cleanup branch.
> The second revision of this pull-request includes a patch from Arnd to modify
> The AT91 Kconfig.
> 
> Thanks, best regards,
> 
> The following changes since commit 9317960fa38ff50ac287904e4c751a169635ecbf:
> 
>   ARM: at91: renamme rm9200 dt file (2013-03-13 17:28:14 +0100)
> 
> are available in the git repository at:
> 
>   git://github.com/at91linux/linux-at91.git tags/at91-soc
> 
> for you to fetch changes up to abac0fd0f6dad6fa01ac8fdfccc796233d0fea30:
> 
>   ARM: at91: make ATAGS support conditional on CONFIG_ATAGS (2013-03-28 09:51:39 +0100)
> 
> ----------------------------------------------------------------
> Introduction of new Atmel Cortex-A5: SAMA5D3 family.
> - Modify AT91 Kconfig to plit ARMv4/5 and ARMv7 arch
> - Modify PMC driver (clocks)
> - Core SAMA5 support
> - Board file, DT files and defconfig
> Add a condition on CONFIG_ATAGS for legacy boards

Pulled, thanks!


-Olof
