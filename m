Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756370Ab3J2EXU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 00:23:20 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:40438 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3J2EXT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 00:23:19 -0400
Date: Tue, 29 Oct 2013 00:23:17 -0400 (EDT)
Message-Id: <20131029.002317.345164763391263319.davem@davemloft.net>
To: hayeswang@realtek.com
Cc: netdev@vger.kernel.org, nic_swsd@realtek.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org
Subject: Re: [PATCH 0/5] r8152 bug fixes
From: David Miller <davem@davemloft.net>
In-Reply-To: <1382961494-2272-1-git-send-email-hayeswang@realtek.com>
References: <1382961494-2272-1-git-send-email-hayeswang@realtek.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Mon, 28 Oct 2013 21:23:19 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hayes Wang <hayeswang@realtek.com>
Date: Mon, 28 Oct 2013 19:58:09 +0800

> These could fix some driver issues.
> 
> Hayes Wang (5):
>   net/usb/r8152: fix tx/rx memory overflow
>   net/usb/r8152: make sure the tx checksum setting is correct
>   net/usb/r8152: modify the tx flow
>   net/usb/r8152: fix incorrect type in assignment
>   net/usb/r8152: code adjust

These are not bug fixes, some of them are just cleanups.

It is inappropriate to mix real bug fixes and non-bug fixes into
a patch series.

You must send purely the bug fixes for 'net' tree, and then later
the code cleanups and other changes targetting the 'net-next' tree.

Also, from patch #5:

====================
 -Something else
====================

That is completely unacceptable.  You must say what changes you are
making, the above says nothing to me nor the person reading your
commit messages in the future.

In general, your commit messages are poorly written in that they
contain not enough information for the person trying to understand
your patches at all.
