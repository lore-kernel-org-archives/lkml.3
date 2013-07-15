Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753224Ab3GORde (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:33:34 -0400
Received: from merlin.infradead.org ([205.233.59.134]:45597 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753082Ab3GORdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:33:32 -0400
Message-ID: <51E4323A.3010903@infradead.org>
Date: Mon, 15 Jul 2013 10:32:42 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>
CC: sfr@canb.auug.org.au, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org, eli@mellanox.com
Subject: Re: randconfig build error with next-20130715, in drivers/net/ethernet/mellanox/mlx5/core
References: <20130715172614.GA4656@krebstar.arl.arizona.edu>
In-Reply-To: <20130715172614.GA4656@krebstar.arl.arizona.edu>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/15/13 10:26, Jim Davis wrote:
> Building with the attached randcom configuration file, which sets
> CONFIG_X86_32=Y
> 
> drivers/built-in.o: In function `average_read':
> debugfs.c:(.text+0x448e91): undefined reference to `__udivdi3'
> make: *** [vmlinux] Error 1
> 

Hi,
You are the third person to report this.

Eli says that he has already fixed it, but a patch was just posted for
it earlier today.

thanks,
-- 
~Randy
