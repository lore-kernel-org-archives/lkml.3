Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753316AbaIIXmd (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 19:42:33 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:33888 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753173AbaIIXm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 19:42:29 -0400
Date: Tue, 09 Sep 2014 16:42:28 -0700 (PDT)
Message-Id: <20140909.164228.1099340284543391478.davem@davemloft.net>
To: andreas@gaisler.com
Cc: sparclinux@vger.kernel.org, sam@ravnborg.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH v2] sparc32, leon: Make leon_dma_ops avaiable when
 !CONFIG_PCI
From: David Miller <davem@davemloft.net>
In-Reply-To: <1410162532-25159-1-git-send-email-andreas@gaisler.com>
References: <1409657655-17846-1-git-send-email-andreas@gaisler.com>
	<1410162532-25159-1-git-send-email-andreas@gaisler.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 09 Sep 2014 16:42:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>
Date: Mon,  8 Sep 2014 09:48:52 +0200

> The leon_dma_ops struct is needed for leon regardless of PCI configuration.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>
> ---
> Changes from v1: Fixed typo in commit message

Applied.
