Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754777Ab3LFAn7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 19:43:59 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:59973 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752665Ab3LFAn4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 19:43:56 -0500
Date: Thu, 05 Dec 2013 19:43:55 -0500 (EST)
Message-Id: <20131205.194355.1677309681391704143.davem@davemloft.net>
To: ydroneaud@opteya.com
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        viro@zeniv.linux.org.uk
Subject: Re: [PATCH v2] net: handle error more gracefully in socketpair()
From: David Miller <davem@davemloft.net>
In-Reply-To: <1386285331.18074.47.camel@localhost.localdomain>
References: <1385979146-13825-1-git-send-email-ydroneaud@opteya.com>
	<20131205.162333.1525865133149454763.davem@davemloft.net>
	<1386285331.18074.47.camel@localhost.localdomain>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.1 (shards.monkeyblade.net [0.0.0.0]); Thu, 05 Dec 2013 16:43:56 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yann Droneaud <ydroneaud@opteya.com>
Date: Fri, 06 Dec 2013 00:15:31 +0100

> AFAIK, using sys_close() seems to be the exception, and writing the file
> descriptor before installing it is the more or less the norm.

What other system call in the kernel writes a file descriptor's value
into the address space of a user process before the file descriptor
is actually usable?

That's really terrible semantically.
