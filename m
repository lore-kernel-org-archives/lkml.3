Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753831AbaJCPPR (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 Oct 2014 11:15:17 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:55571 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753679AbaJCPPM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 Oct 2014 11:15:12 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Antoine Tenart <antoine.tenart@free-electrons.com>,
        dan.carpenter@oracle.com, kou.ishizaki@toshiba.co.jp, jens@de.ibm.com,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] net: spider_net: avoid using signed char for bitops
Date: Fri, 03 Oct 2014 17:15:05 +0200
Message-ID: <9201792.OAu7xPjvdN@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412348517-20352-4-git-send-email-antoine.tenart@free-electrons.com>
References: <1412348517-20352-1-git-send-email-antoine.tenart@free-electrons.com> <1412348517-20352-4-git-send-email-antoine.tenart@free-electrons.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:b6siuZp4WdC7tlkPB4QRI9wTlWJSGHRVhoWBYBRr4Yr
 AMFtOKSTQuFfbPiFpV7xDhjCpiaY4ty7MZE2CK25k3jQq/3ZAy
 WlqPe6Sya4bUfSEUeEF/hFD6cMMjKgNy4arGvw1x6+VkVMmBUz
 7FEdmGecu+0AfbeI1LQfltQMmMV6VFA8Gmd05dHPuJZe7NaB40
 41D5zgPMI3aSoYhg3Dzbv29XhDfYaeHvdR014MNHiwUD7XeNdD
 CLjymlh0FdWEi4yjz2etGjtjoWavN0W2aGQXHlCG56GWoKhEck
 VF9B6ECUltn1HRLqxjd84qbrW///XT7b4wd6dxuHFlaWVl4zok
 a8f71JzgsC4jlr/zv+DQ=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 03 October 2014 17:01:56 Antoine Tenart wrote:
> Signedness bugs may occur when using signed char for bitops,
> depending on if the highest bit is ever used.
> 
> Signed-off-by: Antoine Tenart <antoine.tenart@free-electrons.com>
> 

It's probably worth mentioning here that this cannot happen in this
driver because it's only used in one powerpc-specific chip, and 'char'
is always 'unsigned' on powerpc.

	Arnd
