Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752480Ab3FDJQx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:16:53 -0400
Received: from mail-ob0-f179.google.com ([209.85.214.179]:50534 "EHLO
	mail-ob0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751416Ab3FDJQt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:16:49 -0400
MIME-Version: 1.0
In-Reply-To: <1370013351-7960-1-git-send-email-lee.jones@linaro.org>
References: <1370013351-7960-1-git-send-email-lee.jones@linaro.org>
Date: Tue, 4 Jun 2013 11:16:48 +0200
Message-ID: <CACRpkda9Ao6PpA_aOMghXjRMu54e3VPCa9VV+7Jj_Oa1NHqL2g@mail.gmail.com>
Subject: Re: [PATCH v2] ARM: ux500: Allocate correct amount of memory for the
 u8540 in DT
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Srinidhi KASAGAR <srinidhi.kasagar@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 5:15 PM, Lee Jones <lee.jones@linaro.org> wrote:

> As it stands, the memory node in the u8540 Device Tree is ignored and
> memory is actually stipulated by the bootloader via ATAGS. ARM core
> architecture code then extracts the memory ATAG and inserts it into the
> Device Tree. In the u8540 the LittleKernel bootloader only stipulates
> 512MB of memory; however, the u8540 actually has 2GB. We're taking the
> responsibility to register the remainder from Device Tree here.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied to my ux500-devicetree branch.

Yours,
Linus Walleij
