Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751862AbaDAVgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 17:36:42 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55945 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751513AbaDAVgl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 17:36:41 -0400
Date: Tue, 01 Apr 2014 17:36:39 -0400 (EDT)
Message-Id: <20140401.173639.1201135615627128904.davem@davemloft.net>
To: struan.bartlett@gmail.com
Cc: mpm@selenic.com, linux-kernel@vger.kernel.org, schwab@linux-m68k.org,
        netdev@vger.kernel.org, nikolay@redhat.com, andy.shevchenko@gmail.com,
        gregkh@linuxfoundation.org, jiri@resnulli.us, joe@perches.com,
        alonid@postram.com
Subject: Re: [PATCH v1] netconsole: Add tty driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <CAOte+=Y5bSq96wXUHQnAZQRn4jMf+6V5Py6nU3eLNEW9NaRzzg@mail.gmail.com>
References: <CAOte+=Y5bSq96wXUHQnAZQRn4jMf+6V5Py6nU3eLNEW9NaRzzg@mail.gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 01 Apr 2014 14:36:40 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Struan Bartlett <struan.bartlett@gmail.com>
Date: Tue, 1 Apr 2014 23:13:06 +0200

> Adds tty driver to netconsole module. When module is loaded, it
> creates /dev/netcon0 device and enables support for console=netcon0
> kernel cmdline option, causing /dev/console output to be sent to
> /dev/netcon0. This allows startup/shutdown script output from
> headless platforms to be logged over (secure) network.
> 
> Signed-off-by: Struan Bartlett <struan.bartlett@gmail.com>

Your patch was severely corrupted by your email client, making
your patch unusuable to us.

Please read Documentation/email-clients.txt
