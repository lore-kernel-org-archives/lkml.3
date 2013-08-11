Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294Ab3HKHes (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 03:34:48 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:52108 "EHLO mx01-sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750963Ab3HKHep (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 03:34:45 -0400
Message-ID: <52073E90.2030008@bfs.de>
Date: Sun, 11 Aug 2013 09:34:40 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Julia Lawall <julia.lawall@lip6.fr>
CC: Dan Carpenter <dan.carpenter@oracle.com>,
        Jonathan Cameron <jic23@cam.ac.uk>, kernel-janitors@vger.kernel.org,
        Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/mach-pxa/stargate2.c: use ARRAY_AND_SIZE consistently
References: <1376148353-9699-1-git-send-email-Julia.Lawall@lip6.fr> <20130810223338.GM5502@mwanda> <alpine.DEB.2.02.1308110745030.2072@localhost6.localdomain6>
In-Reply-To: <alpine.DEB.2.02.1308110745030.2072@localhost6.localdomain6>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 11.08.2013 07:48, schrieb Julia Lawall:
> On Sun, 11 Aug 2013, Dan Carpenter wrote:
> 
>> ARRAY_AND_SIZE() macro is horrible, and I would like it if it were
>> removed.  What I meant before was just that probably people will
>> probably complain if we try to remove it.
> 
> Well, I could either wait for someone to defend it, or send a patch 
> getting rid of it and see what happens...  I can't see what could go wrong 
> with
> 
> f(...,
> - ARRAY_AND_SIZE(e)
> + e, ARRAY_SIZE(e)
>   , ...)
> 
> so it should be an easy patch to create.
> 


if it is not to much work, send a patch to get rid of it.
It seems all agree that the disadvantages outweighs it
advantages.

just my 2 cents,
 wh


