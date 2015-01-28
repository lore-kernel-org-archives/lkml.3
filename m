Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759711AbbA1BTe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 20:19:34 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:54256 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759603AbbA1BTc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 20:19:32 -0500
Date: Tue, 27 Jan 2015 17:19:31 -0800 (PST)
Message-Id: <20150127.171931.1483421801202546665.davem@davemloft.net>
To: m-karicheri2@ti.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH net-next v1] net: netcp: remove unused kconfig option
 and code
From: David Miller <davem@davemloft.net>
In-Reply-To: <1422370194-2828-1-git-send-email-m-karicheri2@ti.com>
References: <1422370194-2828-1-git-send-email-m-karicheri2@ti.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 27 Jan 2015 17:19:31 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Murali Karicheri <m-karicheri2@ti.com>
Date: Tue, 27 Jan 2015 09:49:54 -0500

> Currently CPTS is built into the netcp driver even though there is no
> call out to the CPTS driver. This patch removes the dependency in Kconfig
> and remove cpts.o from the Makefile for NetCP.
> 
> Signed-off-by: Murali Karicheri <m-karicheri2@ti.com>

Applied, thank you.
