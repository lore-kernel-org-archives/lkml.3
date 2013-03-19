Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab3CSUVx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Mar 2013 16:21:53 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:47988 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932361Ab3CSUVv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Mar 2013 16:21:51 -0400
Date: Tue, 19 Mar 2013 16:21:49 -0400 (EDT)
Message-Id: <20130319.162149.1369971904943836071.davem@davemloft.net>
To: pebolle@tiscali.nl
Cc: sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] sparc: remove unused "config BITS"
From: David Miller <davem@davemloft.net>
In-Reply-To: <1363712807.1390.26.camel@x61.thuisdomein>
References: <1363708727.1390.16.camel@x61.thuisdomein>
	<20130319.123306.1709006318806942163.davem@davemloft.net>
	<1363712807.1390.26.camel@x61.thuisdomein>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.2.7 (shards.monkeyblade.net [0.0.0.0]); Tue, 19 Mar 2013 13:21:55 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Paul Bolle <pebolle@tiscali.nl>
Date: Tue, 19 Mar 2013 18:06:47 +0100

> On Tue, 2013-03-19 at 12:33 -0400, David Miller wrote:
>> We use this in the Makefile fragments, you cannot remove it.
> 
> From arch/sparc/Makefile:
>     ifeq ($(CONFIG_SPARC32),y)
>     [...]
> 
>     [...]
>     export BITS    := 32
>     [...]
> 
>     else
>     [...]
> 
>     [...]
>     export BITS   := 64
>     [...]
> 
> So $(BITS) is set depending on whether CONFIG_SPARC32 is set or not.
> Using $(BITS) in sparc's Makefiles is not using CONFIG_BITS. That
> doesn't count as usage of "config BITS". 

Ok, I'm convinced now :-)  Applied, thanks!
