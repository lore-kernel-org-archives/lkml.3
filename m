Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965328AbaKNOv4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 09:51:56 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:54158 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964875AbaKNOvz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 09:51:55 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Marek Szyprowski <m.szyprowski@samsung.com>
Cc: Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Tomasz Figa <tomasz.figa@gmail.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        lauraa@codeaurora.org, linux-omap@vger.kernel.org,
        linus.walleij@linaro.org, tony@atomide.com, drake@endlessm.com,
        loeliger@gmail.com, Mark Rutland <mark.rutland@arm.com>
Subject: Re: [PATCH v8 0/7] Enable L2 cache support on Exynos4210/4x12 SoCs
Date: Fri, 14 Nov 2014 15:51:39 +0100
Message-ID: <2593372.vOeyyAKq5M@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <54660DAE.9090601@samsung.com>
References: <1415884694-5868-1-git-send-email-m.szyprowski@samsung.com> <54660DAE.9090601@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:tB66CtoFx2qIdJ+xG/fYhAMZgrdzPS6lhNaL6IgM56m
 vxwm7BOMA7q1FCVQicE73nLLpnbmFhSCD3D51wIw9Eyk6OOeTp
 FrcHrLqIbxqsAsKf46mmlVevhzrx4lnUF7ZhaDsRHswn/uZx2X
 p8yNcZer3JrkijA8xeKfKTg8Ya/1USvya+crsfNzB6GQs1O1Qy
 BcKW5edBpF80qJj1Ogl8bgW4fjO4JUVXAvYC6u+ok+x/mdZKiN
 gxLjExxkvyVuYH8D9AEMAEz2ynEU+kGy23xCfAkn8igbxGKrYV
 iQbscYvBO8pExnOYNSoSfhkmKJJSdkZ76Wk+tTayTQfrdGHxXe
 1uZxJZJO1OHjXgipScOg=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 14 November 2014 15:11:58 Marek Szyprowski wrote:
> 
> I assume that after all comments from previous versions, no more changes 
> are needed
> to this patchset and I would really like to have it queued to v3.19.
> 
> Arnd, Olof: could you take this patchset thought arm-soc tree? It already
> contains all dependencies.
> 
> Kukjin: could you ack this patchset?

I'd rather see this merged through Russell's tree, as most of the patches
are for core code, and only three are for the platform.

For the exynos patches:

Acked-by: Arnd Bergmann <arnd@arndb.de>

	Arnd
