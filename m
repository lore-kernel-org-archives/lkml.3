Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752019AbaAQBap (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 Jan 2014 20:30:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:55869 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751807AbaAQBaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 Jan 2014 20:30:10 -0500
Date: Thu, 16 Jan 2014 17:30:09 -0800 (PST)
Message-Id: <20140116.173009.1297466601669773596.davem@davemloft.net>
To: prabhakar.csengg@gmail.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org, mugunthanvnm@ti.com
Subject: Re: [PATCH] net: davinci_mdio: Fix sparse warning
From: David Miller <davem@davemloft.net>
In-Reply-To: <1389852341-15393-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1389852341-15393-1-git-send-email-prabhakar.csengg@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Prabhakar Lad <prabhakar.csengg@gmail.com>
Date: Thu, 16 Jan 2014 11:35:41 +0530

> From: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
> 
> This patch fixes following sparse warning
> davinci_mdio.c:85:27: warning: symbol 'default_pdata' was not declared. Should it be static?
> Also makes the default_pdata as a constant.
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Applied.
