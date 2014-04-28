Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaD1TNR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Apr 2014 15:13:17 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44817 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751460AbaD1TNN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Apr 2014 15:13:13 -0400
Date: Mon, 28 Apr 2014 14:48:42 -0400 (EDT)
Message-Id: <20140428.144842.1493649251170402770.davem@davemloft.net>
To: standby24x7@gmail.com
Cc: netdev@vger.kernel.org, j.vosburgh@gmail.com, vfalico@gmail.com,
        andy@greyhouse.net, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] net: bonding: Fix format string mismatch in
 bond_sysfs.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <1398699681-27339-1-git-send-email-standby24x7@gmail.com>
References: <1398699681-27339-1-git-send-email-standby24x7@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Mon, 28 Apr 2014 11:48:43 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Masanari Iida <standby24x7@gmail.com>
Date: Tue, 29 Apr 2014 00:41:21 +0900

> Fix format string mismatch in bonding_show_min_links().
> 
> Signed-off-by: Masanari Iida <standby24x7@gmail.com>

Applied, thanks.
