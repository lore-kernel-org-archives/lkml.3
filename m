Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757357AbaIIPFZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 11:05:25 -0400
Received: from mout.kundenserver.de ([212.227.17.24]:58396 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757219AbaIIPFX convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 11:05:23 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Olof Johansson <olof@lixom.net>, arm@kernel.org,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Boris BREZILLON <boris.brezillon@free-electrons.com>,
        =?utf-8?B?R2Hvv71s?= PORTAY <gael.portay@gmail.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Subject: Re: [GIT PULL] at91: cleanup for 3.18 #2
Date: Tue, 09 Sep 2014 17:05:17 +0200
Message-ID: <2942172.hhXGdFhYuO@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1410181016-9944-1-git-send-email-nicolas.ferre@atmel.com>
References: <1410181016-9944-1-git-send-email-nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V02:K0:8dZ+0DXCI+U+d1fbCcl2zBC0kVDz/tLM6BxwWVh9nTh
 umGlnE4y4q24XkKbTD3Q8EBkSzIGQ4BvNMT9iP9RfU15jR0NzN
 hWq/tVumOOfNBANM73wePQz5JocqLK6Lqfx5ezzQ+857KzfqGs
 plEpZOcFCctrmg0jorhyT4rgVKI3qg1A5/V72hKyLWONS3CJF9
 AkRJ/l1G5AYA34NZJ+A8E75etUH+JtcYXRlbKgoWkw8dyftdOr
 8IIOvsibKFpE6VGd5++yNOH5KTNiAV/kjHfu+6D7aIBkLK9QD8
 V/G47dvXIlT4ovcGeo1jKT2Yxs3kQi5uOr6iN1geK7U/tWJtQF
 ai87jFpg3OcFK/AxEgcg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 08 September 2014 14:56:56 Nicolas Ferre wrote:
> Another pull-request that can be considered as "fixes-non-critical" or
> "cleanup". I choose the latest as the patches are a little bit more than just
> fixes.  The bug found by Ga�l is present on AT91 kernels for a long time so I
> decided to avoid trying to submit it during the "-rc phase" or adding a
> "stable" tag.
> This material goes on top of the previous "cleanup" pull-request that you took
> but comes with no dependency.
> 

Ok, pulled into next/cleanup, thanks!

	Arnd
