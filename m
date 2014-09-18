Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757669AbaIRGWl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 02:22:41 -0400
Received: from casper.infradead.org ([85.118.1.10]:33855 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751277AbaIRGWk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 02:22:40 -0400
Message-ID: <541A7A2B.4090305@infradead.org>
Date: Wed, 17 Sep 2014 23:22:35 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
MIME-Version: 1.0
To: Masanari Iida <standby24x7@gmail.com>, linux-kernel@vger.kernel.org,
        trivial@kernel.org
CC: realmz6@gmail.com, tglx@linutronix.de, jason@lakedaemon.net
Subject: Re: [PATCH] [trivial] treewide: Fix typos in Kconfig
References: <1411009782-9070-1-git-send-email-standby24x7@gmail.com>
In-Reply-To: <1411009782-9070-1-git-send-email-standby24x7@gmail.com>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/17/14 20:09, Masanari Iida wrote:
> This patch fix spelling typos found in Kconfig.
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: Randy Dunlap <rdunlap@infradead.org>

Thanks.

> ---
>  arch/blackfin/Kconfig           | 2 +-
>  arch/mips/cavium-octeon/Kconfig | 2 +-
>  drivers/i2c/busses/Kconfig      | 2 +-
>  drivers/irqchip/Kconfig         | 2 +-
>  drivers/platform/x86/Kconfig    | 8 ++++----
>  drivers/usb/host/Kconfig        | 2 +-
>  6 files changed, 9 insertions(+), 9 deletions(-)


-- 
~Randy
