Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933184AbaBURUF (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:20:05 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:41652 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932519AbaBURUB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:20:01 -0500
Date: Fri, 21 Feb 2014 12:19:59 -0500 (EST)
Message-Id: <20140221.121959.1500262643643918996.davem@davemloft.net>
To: dhowells@redhat.com
Cc: sfr@canb.auug.org.au, akpm@linux-foundation.org,
        linux-next@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: linux-next: manual merge of the akpm-current tree with the
 sparc tree
From: David Miller <davem@davemloft.net>
In-Reply-To: <28092.1392982364@warthog.procyon.org.uk>
References: <20140221174238.acefa05c8a5e71b06155d32d@canb.auug.org.au>
	<28092.1392982364@warthog.procyon.org.uk>
X-Mailer: Mew version 6.5 on Emacs 24.3 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Fri, 21 Feb 2014 09:20:01 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Howells <dhowells@redhat.com>
Date: Fri, 21 Feb 2014 11:32:44 +0000

> Stephen Rothwell <sfr@canb.auug.org.au> wrote:
> 
>> Today's linux-next merge of the akpm-current tree got a conflict in
>> drivers/sbus/char/jsflash.c between commit 967f038e491b ("Sparc:
>> sparc_cpu_model isn't in asm/system.h any more [ver #2]") from the sparc
>> tree and commit 695f43eb1721 ("asm/system.h: sparc: sparc_cpu_model isn't
>> in asm/system.h any more") from the akpm-current tree.
> 
> I think Andrew's is an old version.

Right.
