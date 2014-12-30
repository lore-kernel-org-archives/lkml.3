Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751874AbaL3VOZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Dec 2014 16:14:25 -0500
Received: from shards.monkeyblade.net ([149.20.54.216]:35551 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751321AbaL3VOX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Dec 2014 16:14:23 -0500
Date: Tue, 30 Dec 2014 16:14:17 -0500 (EST)
Message-Id: <20141230.161417.1724826704176493969.davem@davemloft.net>
To: xerofoify@gmail.com
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: Question about FIXME in au1xxx-ide.c
From: David Miller <davem@davemloft.net>
In-Reply-To: <54A2E158.9020407@gmail.com>
References: <54A2E158.9020407@gmail.com>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Tue, 30 Dec 2014 13:14:22 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: nick <xerofoify@gmail.com>
Date: Tue, 30 Dec 2014 12:31:04 -0500

> Greetings David,
> I am wondering about the fix me in the file,au1xxx-ide.c for
> the function,auide_ddma_init. While it's obvious to check the
> return code of the function called below the FIXME comment,it
> seems to be that there is more to this issue and therefore I 
> have a few questions. The first being can this device fail and
> the system will function properly? The second question being don't
> we need to remove the device if the allocation fails in the creation
> of the data structures for it's use by the kernel as otherwise aren't
> we leaking memory?

I have no idea why the FIXME comment is there, I didn't write this
driver nor have I ever made any changes to it.
