Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932734AbaLJS0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 13:26:00 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:46481 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932414AbaLJSZ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 13:25:59 -0500
Date: Wed, 10 Dec 2014 13:25:56 -0500 (EST)
Message-Id: <20141210.132556.1903423939455937117.davem@davemloft.net>
To: viro@ZenIV.linux.org.uk
Cc: netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: the next chunk of iov_iter-net stuff for review
From: David Miller <davem@davemloft.net>
In-Reply-To: <20141209224928.GL22149@ZenIV.linux.org.uk>
References: <20141209212337.GK22149@ZenIV.linux.org.uk>
	<20141209.163758.1934464464299516168.davem@davemloft.net>
	<20141209224928.GL22149@ZenIV.linux.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Wed, 10 Dec 2014 10:25:58 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Al Viro <viro@ZenIV.linux.org.uk>
Date: Tue, 9 Dec 2014 22:49:28 +0000

> OK, rebase is in
> git://git.kernel.org/pub/scm/linux/kernel/git/viro/vfs.git for-davem-2,
> individual patches - in followups (first 13 - iov_iter, then 12 net-related)

All looks good to me, pulled, thanks Al!
