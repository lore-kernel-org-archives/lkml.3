Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752151AbaFDVzl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Jun 2014 17:55:41 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37221 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752179AbaFDVzi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Jun 2014 17:55:38 -0400
Date: Wed, 04 Jun 2014 14:55:36 -0700 (PDT)
Message-Id: <20140604.145536.2297917264161823878.davem@davemloft.net>
To: Li.Xiubo@freescale.com
Cc: claudiu.manoil@freescale.com, jingchang.lu@freescale.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] gianfar: Fix the section mismatch warnings.
From: David Miller <davem@davemloft.net>
In-Reply-To: <1401871756-29231-1-git-send-email-Li.Xiubo@freescale.com>
References: <1401871756-29231-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 04 Jun 2014 14:55:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xiubo Li <Li.Xiubo@freescale.com>
Date: Wed, 4 Jun 2014 16:49:16 +0800

> Building with CONFIG_DEBUG_SECTION_MISMATCH enabled, the following
> WARNING is occured:
> 
>   LD      drivers/net/built-in.o
> WARNING: drivers/net/built-in.o(.text+0xcd4c): Section mismatch in
> reference from the function gfar_probe() to the function
> .init.text:gfar_init_addr_hash_table()
> The function gfar_probe() references
> the function __init gfar_init_addr_hash_table().
> This is often because gfar_probe lacks a __init
> annotation or the annotation of gfar_init_addr_hash_table is wrong.
> 
> Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>

Applied, thanks.
