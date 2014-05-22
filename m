Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752638AbaEVUUj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:20:39 -0400
Received: from mout.gmx.com ([74.208.4.201]:55516 "EHLO mout.gmx.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752447AbaEVUUh (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:20:37 -0400
Date: Fri, 23 May 2014 01:49:22 +0530 (IST)
From: Govindarajulu Varadarajan <_govind@gmx.com>
X-X-Sender: gvaradar@ws.cisco
To: Jim Davis <jim.epost@gmail.com>
cc: Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-next <linux-next@vger.kernel.org>,
        linux-kernel <linux-kernel@vger.kernel.org>, benve@cisco.com,
        ssujith@cisco.com, _govind@gmx.com, neepatel@cisco.com,
        netdev <netdev@vger.kernel.org>
Subject: Re: randconfig build error with next-20140522, in
 drivers/net/ethernet/cisco/enic/enic_main.c
In-Reply-To: <CA+r1ZhgW_Du8VUCmOof-MYnOun8Pq0FYTu4cG5NAOt3vkztWBw@mail.gmail.com>
Message-ID: <alpine.LNX.2.03.1405230148040.15994@ws.cisco>
References: <CA+r1ZhgW_Du8VUCmOof-MYnOun8Pq0FYTu4cG5NAOt3vkztWBw@mail.gmail.com>
User-Agent: Alpine 2.03 (LNX 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII; format=flowed
X-Provags-ID: V03:K0:0FCiCkrjHDddH0ClpWZ5FvI2Ccvjpizrs2Qxo9gN5vmAPIh8qg0
 OJcJi5q8BkANsXinUWIg/kt36Yh8NDQkfagw2rdrV2Nzivg6UXz1V7cxeynTds1BYUkZEQE
 dyOxRDsm3n9OFF6lvnCJxU6TtmHM0l5x7qbepP7bophm+KAAOyXIhcY6OO7WIhVcMH0ALK2
 CovJeS1I7P4Pop1xQ8jWw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 22 May 2014, Jim Davis wrote:

> Building with the attached random configuration file,
>
> drivers/built-in.o: In function `enic_poll_msix':
> enic_main.c:(.text+0x48710a): undefined reference to `__udivdi3'
> make: *** [vmlinux] Error 1
>

Looks like 64 bit divide issue. Will look into it.

Thanks for reporting.

Govind
