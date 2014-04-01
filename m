Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751949AbaDAVha (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:37:30 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55960 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751627AbaDAVh2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:37:28 -0400
Date: Tue, 01 Apr 2014 17:37:26 -0400 (EDT)
Message-Id: <20140401.173726.1757895946889652328.davem@davemloft.net>
To: struan.bartlett@gmail.com
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        netdev@vger.kernel.org, nikolay@redhat.com, andy.shevchenko@gmail.com,
        gregkh@linuxfoundation.org, jiri@resnulli.us, joe@perches.com,
        alonid@postram.com
Subject: Re: [PATCH v2] netconsole: Add tty driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <533B2F03.6060008@gmail.com>
References: <533B2F03.6060008@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Apr 2014 14:37:28 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Struan Bartlett <struan.bartlett@gmail.com>
Date: Tue, 01 Apr 2014 23:26:27 +0200

> Adds tty driver to netconsole module. When module is loaded,
> creates /dev/netcon0 device and enables support for console=netcon0
> kernel cmdline option, causing /dev/console output to be sent to
> /dev/netcon0. This allows startup/shutdown script output from
> headless platforms to be logged over (secure) network.
> 
> To: Matt Mackall <mpm@selenic.com>
> Signed-off-by: Struan Bartlett <struan.bartlett@gmail.com>
> ---
> 
> Changes since v1:
>  * Fixed whitespace mangled by broken mailer

It's still not submitted cleanly, look at what it looks like
in patchwork:

http://patchwork.ozlabs.org/patch/336171/
