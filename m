Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753680AbbA2Gcw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 01:32:52 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:36564 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752476AbbA2Gcu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 01:32:50 -0500
Date: Wed, 28 Jan 2015 22:32:49 -0800 (PST)
Message-Id: <20150128.223249.779296549693168395.davem@davemloft.net>
To: karl.beldan@gmail.com
Cc: karl.beldan@rivierawaves.com, viro@ZenIV.linux.org.uk,
        eric.dumazet@gmail.com, arnd@arndb.de, vapier@gentoo.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        stable@vger.kernel.org
Subject: Re: [PATCH v2] lib/checksum.c: fix carry in csum_tcpudp_nofold
From: David Miller <davem@davemloft.net>
In-Reply-To: <1422439091-31413-1-git-send-email-karl.beldan@rivierawaves.com>
References: <1422439091-31413-1-git-send-email-karl.beldan@rivierawaves.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 28 Jan 2015 22:32:50 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Karl Beldan <karl.beldan@gmail.com>
Date: Wed, 28 Jan 2015 10:58:11 +0100

> The carry from the 64->32bits folding was dropped, e.g with:
> saddr=0xFFFFFFFF daddr=0xFF0000FF len=0xFFFF proto=0 sum=1,
> csum_tcpudp_nofold returned 0 instead of 1.
> 
> Signed-off-by: Karl Beldan <karl.beldan@rivierawaves.com>

Applied, thanks.
