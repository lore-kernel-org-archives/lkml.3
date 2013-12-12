Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751678Ab3LLAfl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:35:41 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60688 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751000Ab3LLAfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:35:40 -0500
Date: Wed, 11 Dec 2013 19:35:35 -0500 (EST)
Message-Id: <20131211.193535.1248497431790934663.davem@davemloft.net>
To: mchan@broadcom.com
Cc: sergei.shtylyov@cogentembedded.com, natg@google.com, nsujir@broadcom.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net-tg3: Initialize REG_BASE_ADDR at PCI config offset
 120 to 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386804078.1752.58.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
References: <1386701379.1752.26.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
	<20131210.222313.694303616856894486.davem@davemloft.net>
	<1386804078.1752.58.camel@LTIRV-MCHAN1.corp.ad.broadcom.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 16:35:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Michael Chan <mchan@broadcom.com>
Date: Wed, 11 Dec 2013 15:21:18 -0800

> So it looks to me that we are in good shape.  Thanks.

Thanks for checking this out, and providing such detailed
analysis.
