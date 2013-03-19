Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933105Ab3CSQdL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 12:33:11 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:44908 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754480Ab3CSQdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 12:33:09 -0400
Date: Tue, 19 Mar 2013 12:33:06 -0400 (EDT)
Message-Id: <20130319.123306.1709006318806942163.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: remove unused "config BITS"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363708727.1390.16.camel@x61.thuisdomein>
References: <1363708727.1390.16.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 09:33:13 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 19 Mar 2013 16:58:47 +0100

> sparc's asm/module.h got removed in commit
> 786d35d45cc40b2a51a18f73e14e135d47fdced7 ("Make most arch asm/module.h
> files use asm-generic/module.h"). That removed the only two uses of this
> Kconfig symbol. So we can remove its entry too.
> 
> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Eyeball tested.

We use this in the Makefile fragments, you cannot remove it.
