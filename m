Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755501Ab3DRLJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 07:09:32 -0400
Received: from mail-we0-f181.google.com ([74.125.82.181]:49284 "EHLO
	mail-we0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752652Ab3DRLJa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 07:09:30 -0400
Date: Thu, 18 Apr 2013 12:09:18 +0100
From: Lee Jones <lee.jones@linaro.org>
To: Arnd Bergmann <arnd@arndb.de>
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
Subject: Re: [PATCH 07/32] ARM: ux500: Supply address location names for the
 DMA40 DMA controller
Message-ID: <20130418110918.GC27903@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-8-git-send-email-lee.jones@linaro.org>
 <201304181248.36597.arnd@arndb.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <201304181248.36597.arnd@arndb.de>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 18 Apr 2013, Arnd Bergmann wrote:

> On Thursday 18 April 2013, Lee Jones wrote:
> > The DMA40 controller uses two sets of base addresses. In order to have
> > them automatically setup as resources by the Open Format framework we
> > have to set names for them. The names have to be the same as the ones
> > used to fetch them back out of the resource structure.
> > 
> > Signed-off-by: Lee Jones <lee.jones@linaro.org>
> 
> Typo: s/Open Format/Open Firmware/
> 
> To be more specific, just write of_platform framework. Note that we
> still get resources without passing the names, they are just not
> named in that case and have to be retrieved by index.

Changed to:

The DMA40 controller uses two sets of base addresses. In order to have
the resources setup by the of_platform framework so they are searchable
by name instead of index, we have to set names for them. The names have
to be the same as the ones used to fetch them back out of the resource
structure.

> You should also document the strings in the binding document.

Done.

-- 
Lee Jones
Linaro ST-Ericsson Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
