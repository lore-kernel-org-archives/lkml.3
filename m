Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751994Ab3LLAyh (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 19:54:37 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:60789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751155Ab3LLAyc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 19:54:32 -0500
Date: Wed, 11 Dec 2013 19:54:31 -0500 (EST)
Message-Id: <20131211.195431.261557837240498212.davem@davemloft.net>
To: olof@lixom.net
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org
Subject: Re: [PATCH] net: eth: cpsw: 64-bit phys_addr_t and sparse cleanup
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386806287-6564-1-git-send-email-olof@lixom.net>
References: <1386806287-6564-1-git-send-email-olof@lixom.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Wed, 11 Dec 2013 16:54:32 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Olof Johansson <olof@lixom.net>
Date: Wed, 11 Dec 2013 15:58:07 -0800

> Minor fix for printk format of a phys_addr_t, and the switch of two local
> functions to static since they're not used outside of the file.
> 
> Signed-off-by: Olof Johansson <olof@lixom.net>

Applied.
