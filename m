Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750958AbaAECF7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 Jan 2014 21:05:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:44933 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750734AbaAECF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 Jan 2014 21:05:58 -0500
Date: Sat, 04 Jan 2014 21:05:56 -0500 (EST)
Message-Id: <20140104.210556.1496163796108456860.davem@davemloft.net>
To: ethan.kernel@gmail.com
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: replace __GFP_NOFAIL with GFP_ATOMIC in
 mdesc_kmalloc()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386773661-921-1-git-send-email-ethan.kernel@gmail.com>
References: <1386773661-921-1-git-send-email-ethan.kernel@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Sat, 04 Jan 2014 18:05:57 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ethan Zhao <ethan.kernel@gmail.com>
Date: Wed, 11 Dec 2013 22:54:21 +0800

> Has kmalloc() failure checking there, so it is unnecessary to allocate with
> __GFP_NOFAIL flag that might block forever.
> 
> Signed-off-by: Ethan Zhao <ethan.kernel@gmail.com>

Please submit sparc patches with sparclinux@vger.kernel.org at least
CC:'d.
