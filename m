Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759930AbaLLCxp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Dec 2014 21:53:45 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59017 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751776AbaLLCxo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Dec 2014 21:53:44 -0500
Date: Thu, 11 Dec 2014 21:53:42 -0500 (EST)
Message-Id: <20141211.215342.709080245552027724.davem@davemloft.net>
To: andreas@gaisler.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org,
        software@gaisler.com
Subject: Re: [PATCH] sparc32,leon: Align ccall_info to prevent unaligned
 traps on crosscall
From: David Miller <davem@davemloft.net>
In-Reply-To: <1417773328-10396-1-git-send-email-andreas@gaisler.com>
References: <1417773328-10396-1-git-send-email-andreas@gaisler.com>
X-Mailer: Mew version 6.6 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Thu, 11 Dec 2014 18:53:43 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andreas Larsson <andreas@gaisler.com>
Date: Fri,  5 Dec 2014 10:55:28 +0100

> It is being filled in using std in leon_cross_call.
> 
> Signed-off-by: Andreas Larsson <andreas@gaisler.com>

Applied.
