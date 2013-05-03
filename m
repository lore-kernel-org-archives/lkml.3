Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763415Ab3ECT3f (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 15:29:35 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:33375 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762324Ab3ECT3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 15:29:34 -0400
MIME-Version: 1.0
In-Reply-To: <1367591569-32197-3-git-send-email-lee.jones@linaro.org>
References: <1367591569-32197-1-git-send-email-lee.jones@linaro.org>
	<1367591569-32197-3-git-send-email-lee.jones@linaro.org>
Date: Fri, 3 May 2013 21:29:33 +0200
Message-ID: <CACRpkdak+tbRM7fbKNEWh4H_YipC7B4-MxmEdnsQG65tqzG5JQ@mail.gmail.com>
Subject: Re: [PATCH 02/63] ARM: ux500: Setup the DMA40 driver's DT node using
 the new DMA API
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

On Fri, May 3, 2013 at 4:31 PM, Lee Jones <lee.jones@linaro.org> wrote:

> The new DMA is now available, so let's use it to setup ST-Ericsson's
> DMA40 driver when Device Tree is enabled.
>
> Acked-by: Arnd Bergmann <arnd@arndb.de>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Applied to my ux500-devicetree branch.

Thanks!
Linus Walleij
