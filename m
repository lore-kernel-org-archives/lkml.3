Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752815AbaJFTWz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Oct 2014 15:22:55 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:37260 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859AbaJFTWy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Oct 2014 15:22:54 -0400
Date: Mon, 06 Oct 2014 15:22:51 -0400 (EDT)
Message-Id: <20141006.152251.1468043820451352291.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: herbert@gondor.apana.org.au, linux-kernel@vger.kernel.org,
        linux-crypto@vger.kernel.org
Subject: Re: [PATCH] crypto: Remove unnecessary KERN_INFO from testmgr.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412609874-22311-1-git-send-email-standby24x7@gmail.com>
References: <1412609874-22311-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 06 Oct 2014 12:22:53 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Tue,  7 Oct 2014 00:37:54 +0900

> This patch remove unncessary KERN_INFO from pr_info within testmgr.c
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Acked-by: David S. Miller <davem@davemloft.net>
