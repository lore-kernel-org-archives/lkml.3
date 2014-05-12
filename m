Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758738AbaELOl0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 10:41:26 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:58364 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758554AbaELOlZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 10:41:25 -0400
Date: Mon, 12 May 2014 10:41:23 -0400 (EDT)
Message-Id: <20140512.104123.348250032130742338.davem@davemloft.net>
To: xufeng.zhang@windriver.com
Cc: steffen.klassert@secunet.com, herbert@gondor.apana.org.au,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC][PATCH] af_key: return error when meet errors on
 sendmsg() syscall
From: David Miller <davem@davemloft.net>
In-Reply-To: <53706495.1050303@windriver.com>
References: <1399614455-10551-1-git-send-email-xufeng.zhang@windriver.com>
	<20140512.011141.74073195599318391.davem@davemloft.net>
	<53706495.1050303@windriver.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 12 May 2014 07:41:25 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Xufeng Zhang <xufeng.zhang@windriver.com>
Date: Mon, 12 May 2014 14:05:09 +0800

> I know what you mean, but isn't the kernel API aimed to facilitate the
> implementation of user space?

Yes, but as I stated the communication is message oriented and this
includes the errors.
