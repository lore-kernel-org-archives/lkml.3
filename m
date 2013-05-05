Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751298Ab3EEBaX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 4 May 2013 21:30:23 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:34684 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750810Ab3EEBaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 4 May 2013 21:30:22 -0400
Date: Sat, 04 May 2013 21:32:14 -0400 (EDT)
Message-Id: <20130504.213214.284834179118895616.davem@davemloft.net>
To: federico.vaga@gmail.com
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] sparc/kernel/vio.c: add put_device() after
 device_find_child()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1366036972-9240-1-git-send-email-federico.vaga@gmail.com>
References: <1366036972-9240-1-git-send-email-federico.vaga@gmail.com>
X-Mailer: Mew version 6.4 on Emacs 23.4 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Sat, 04 May 2013 18:30:21 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Federico Vaga <federico.vaga@gmail.com>
Date: Mon, 15 Apr 2013 16:42:52 +0200

> The vio_remove() function uses device_find_child() but it does not drop
> the reference of the retrieved child.
> 
> Signed-off-by: Federico Vaga <federico.vaga@gmail.com>

Applied.
