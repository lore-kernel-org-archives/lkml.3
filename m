Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763361Ab3DCUmn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Apr 2013 16:42:43 -0400
Received: from mail-ie0-f182.google.com ([209.85.223.182]:42965 "EHLO
	mail-ie0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763292Ab3DCUmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Apr 2013 16:42:42 -0400
MIME-Version: 1.0
In-Reply-To: <1364908916-29803-6-git-send-email-lee.jones@linaro.org>
References: <1364908916-29803-1-git-send-email-lee.jones@linaro.org>
	<1364908916-29803-6-git-send-email-lee.jones@linaro.org>
Date: Wed, 3 Apr 2013 22:42:41 +0200
Message-ID: <CACRpkda8Zfc_AvHkqACA7UjdSSAphbu5rUBBktN_awwiSTQAaw@mail.gmail.com>
Subject: Re: [PATCH 6/9] ARM: ux500: Create a new of_dev_auxdata structure for
 u8540 enablement
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 2, 2013 at 3:21 PM, Lee Jones <lee.jones@linaro.org> wrote:

> If we attempt to use the existing u8500 of_dev_auxdata struct to boot
> the u8540, we fail to obtain a console, due to a lack of DMA support
> on the platform.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Patch applied.

Thanks,
Linus Walleij
