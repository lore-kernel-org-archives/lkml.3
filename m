Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754642AbaJJSZu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Oct 2014 14:25:50 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:55789 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751541AbaJJSZs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Oct 2014 14:25:48 -0400
Date: Fri, 10 Oct 2014 14:25:46 -0400 (EDT)
Message-Id: <20141010.142546.2200998192474741214.davem@davemloft.net>
To: akshaysarode21@gmail.com
Cc: john.stultz@linaro.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Checkpatch: coding style errors in Nvidia ethernet
 driver
From: David Miller <davem@davemloft.net>
In-Reply-To: <1412928102-1696-1-git-send-email-akshaysarode21@gmail.com>
References: <1412928102-1696-1-git-send-email-akshaysarode21@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 10 Oct 2014 11:25:48 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Akshay Sarode <akshaysarode21@gmail.com>
Date: Fri, 10 Oct 2014 13:31:42 +0530

> ERROR: "foo* bar" should be "foo *bar"
> ERROR: do not initialise statics to 0 or NULL
> CHECK: spinlock_t definition without comment
> Signed-off-by: Akshay Sarode <akshaysarode21@gmail.com>

The Subject "Subsystem: " prefix is meant to refer to what area of
the kernel you are changing.

You aren't making changes to "Checkpatch: " so that isn't an
appropriate prefix.  Someone scanning the commit header lines
won't be able to tell what part of the kernel your change is
touching.

In this case you should use "nvidia: " as your subsystem
prefix.
