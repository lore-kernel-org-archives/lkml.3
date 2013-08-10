Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758666Ab3HJRtx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 13:49:53 -0400
Received: from mx01-sz.bfs.de ([194.94.69.67]:9577 "EHLO mx01-sz.bfs.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753292Ab3HJRtw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 13:49:52 -0400
Message-ID: <52067D3A.2090505@bfs.de>
Date: Sat, 10 Aug 2013 19:49:46 +0200
From: walter harms <wharms@bfs.de>
Reply-To: wharms@bfs.de
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; de; rv:1.9.1.16) Gecko/20101125 SUSE/3.0.11 Thunderbird/3.0.11
MIME-Version: 1.0
To: Joe Perches <joe@perches.com>
CC: Julia Lawall <Julia.Lawall@lip6.fr>, Jonathan Cameron <jic23@cam.ac.uk>,
        kernel-janitors@vger.kernel.org, Eric Miao <eric.y.miao@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        Haojian Zhuang <haojian.zhuang@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arch/arm/mach-pxa/stargate2.c: use ARRAY_AND_SIZE consistently
References: <1376148353-9699-1-git-send-email-Julia.Lawall@lip6.fr> <1376148738.2083.17.camel@joe-AO722>
In-Reply-To: <1376148738.2083.17.camel@joe-AO722>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



Am 10.08.2013 17:32, schrieb Joe Perches:
> On Sat, 2013-08-10 at 17:25 +0200, Julia Lawall wrote:
>> From: Julia Lawall <Julia.Lawall@lip6.fr>
>>
>> Because ARRAY_AND_SIZE changes the apparent arity of a function, if it is
>> used for one call to a given function, it would be better, if possible, to
>> use it for all of them.
> 
> I think it'd be better to remove ARRAY_AND_SIZE instead.
> 

+1

:)

re,
 wh
