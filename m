Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755511Ab3FDP6S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 11:58:18 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:57443 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754825Ab3FDP6P (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 11:58:15 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Lee Jones <lee.jones@linaro.org>, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 2/2] ARM: ux500: Silence compiler warnings due to missing __cpuinitdata
Date: Tue, 04 Jun 2013 17:57:51 +0200
Message-ID: <1916856.3pBBOMscik@wuerfel>
User-Agent: KMail/4.10.3 (Linux/3.9.0-2-generic; KDE/4.10.3; x86_64; ; )
In-Reply-To: <1370360208-6500-2-git-send-email-lee.jones@linaro.org>
References: <1370360208-6500-1-git-send-email-lee.jones@linaro.org> <1370360208-6500-2-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:1wMYnlrDz3PerQEadnbc5fdI26cH5TL57C9O0VDPeNP
 A5aa7MrvkjPekVVDU/SlHLnV4gySGGnmpqPIvoLVDyVwvMKYlp
 08yyaPLZxIg37AiCkYkKaERq29g6DG6hbTiMvaoz2S44KZC7YJ
 gGKfMkjEDOFmOSVSN8JDk86r0I1bxmAobxUxlBA8f213e0DRgi
 mvB5gLdqRQV1D0tjubza5gLtpTlxL6AvRByRnxsG1xh0sOnZ2g
 pYYr0By/WNuFvoSvBpz8FXy6PAjoZ7lf4sA9ypRNAlQ58eKFwS
 q+/5pkTj4LKjSzDuxtm7tYHElxc0MJWojQs16AP8fXzMidacLA
 0UUf3/FVtXFIlxV4kcA8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 04 June 2013 16:36:48 Lee Jones wrote:
> WARNING: vmlinux.o(.text.unlikely+0x25c): Section mismatch in reference \
>   from the function write_pen_release() to the variable                 \
>   .cpuinit.data:pen_release
> The function write_pen_release() references
> the variable __cpuinitdata pen_release.
> This is often because write_pen_release lacks a __cpuinitdata
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I don't see bug on my machine. Are you sure it's not already fixed in 
a different way in linux-next?

	Arnd
