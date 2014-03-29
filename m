Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752346AbaC2WU6 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 29 Mar 2014 18:20:58 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:51092 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751775AbaC2WU4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 29 Mar 2014 18:20:56 -0400
Date: Sat, 29 Mar 2014 18:20:54 -0400 (EDT)
Message-Id: <20140329.182054.1947915200276978934.davem@davemloft.net>
To: B45475@freescale.com
Cc: linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        B07421@freescale.com, linux-kernel@vger.kernel.org,
        mugunthanvnm@ti.com, zonque@gmail.com, helmut.schaa@googlemail.com,
        R63061@freescale.com
Subject: Re: [PATCH v2] phy/at8031: enable at8031 to work on interrupt mode
From: David Miller <davem@davemloft.net>
In-Reply-To: <1395992381-23094-1-git-send-email-B45475@freescale.com>
References: <1395992381-23094-1-git-send-email-B45475@freescale.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 29 Mar 2014 15:20:56 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Zhao Qiang <B45475@freescale.com>
Date: Fri, 28 Mar 2014 15:39:41 +0800

> The at8031 can work on polling mode and interrupt mode.
> Add ack_interrupt and config intr funcs to enable
> interrupt mode for it.
> 
> Signed-off-by: Zhao Qiang <B45475@freescale.com>
> ---
> changes for v2:
> 	- when interrupt is not enabled, write 0 to interrupt enbale register
> 	- delete a inner parens not needed

Applied to net-next, thanks.
