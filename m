Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752083AbaLFF3u (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Dec 2014 00:29:50 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60278 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750746AbaLFF3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Dec 2014 00:29:48 -0500
Date: Fri, 05 Dec 2014 21:34:18 -0800 (PST)
Message-Id: <20141205.213418.1220384750443838103.davem@davemloft.net>
To: LinoSanfilippo@gmx.de
Cc: stephen@networkplumber.org, mlindner@marvell.com, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] skge: Unmask interrupts in case of spurious interrupts
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417348291-1302-1-git-send-email-LinoSanfilippo@gmx.de>
References: <1417348291-1302-1-git-send-email-LinoSanfilippo@gmx.de>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 05 Dec 2014 21:29:48 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Lino Sanfilippo <LinoSanfilippo@gmx.de>
Date: Sun, 30 Nov 2014 12:51:31 +0100

> In case of a spurious interrupt dont forget to reenable the interrupts that
> have been masked by reading the interrupt source register.
> 
> Signed-off-by: Lino Sanfilippo <LinoSanfilippo@gmx.de>

Applied.
