Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753283Ab3CJVMh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 10 Mar 2013 17:12:37 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:53592 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752139Ab3CJVMg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 10 Mar 2013 17:12:36 -0400
Date: Sun, 10 Mar 2013 17:12:38 -0400 (EDT)
Message-Id: <20130310.171238.330349067962026661.davem@davemloft.net>
To: gang.chen@asianux.com
Cc: linux@arm.linux.org.uk, mgherzan@gmail.com, nschichan@freebox.fr,
        daniel.borkmann@tik.ee.ethz.ch, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM:net: an issue for k which is u32, never < 0
From: David Miller <davem@davemloft.net>
In-Reply-To: <513BECDA.3030803@asianux.com>
References: <513BECDA.3030803@asianux.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sun, 10 Mar 2013 14:12:34 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chen Gang <gang.chen@asianux.com>
Date: Sun, 10 Mar 2013 10:15:54 +0800

> 
>   k is u32 which never < 0, need type cast, or cause issue.
> 
> Signed-off-by: Chen Gang <gang.chen@asianux.com>

Who will apply this, ARM folks or me?
