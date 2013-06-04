Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755318Ab3FDQi2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:38:28 -0400
Received: from mail-ea0-f172.google.com ([209.85.215.172]:60226 "EHLO
	mail-ea0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751802Ab3FDQiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:38:24 -0400
Date: Tue, 4 Jun 2013 17:38:19 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, srinidhi.kasagar@stericsson.com
Subject: Re: [PATCH 2/2] ARM: ux500: Silence compiler warnings due to missing
 __cpuinitdata
Message-ID: <20130604163819.GO3370@gmail.com>
References: <1370360208-6500-1-git-send-email-lee.jones@linaro.org>
 <1370360208-6500-2-git-send-email-lee.jones@linaro.org>
 <1916856.3pBBOMscik@wuerfel>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1916856.3pBBOMscik@wuerfel>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 04 Jun 2013, Arnd Bergmann wrote:

> On Tuesday 04 June 2013 16:36:48 Lee Jones wrote:
> > WARNING: vmlinux.o(.text.unlikely+0x25c): Section mismatch in reference \
> >   from the function write_pen_release() to the variable                 \
> >   .cpuinit.data:pen_release
> > The function write_pen_release() references
> > the variable __cpuinitdata pen_release.
> > This is often because write_pen_release lacks a __cpuinitdata
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> I don't see bug on my machine. Are you sure it's not already fixed in 
> a different way in linux-next?

It's a possibility.

Basically I have a v3.10-rc3 kernel and I did:

`git checkout next/master -- scripts`

I assumed some extra checking appeared in the scripts directory, so I
just fixed the warnings and sent out a patch.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
