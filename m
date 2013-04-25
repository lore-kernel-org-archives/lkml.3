Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758617Ab3DYNQH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Apr 2013 09:16:07 -0400
Received: from mail-ob0-f173.google.com ([209.85.214.173]:58995 "EHLO
	mail-ob0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757907Ab3DYNQF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Apr 2013 09:16:05 -0400
MIME-Version: 1.0
In-Reply-To: <1366729394-11406-11-git-send-email-lee.jones@linaro.org>
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
	<1366729394-11406-11-git-send-email-lee.jones@linaro.org>
Date: Thu, 25 Apr 2013 15:16:04 +0200
Message-ID: <CACRpkdbHm8pdm+hTRHK8d32G4h9u=RBMgsLEmMeBBRGWPai5Ag@mail.gmail.com>
Subject: Re: [PATCH 10/10] ARM: ux500: Remove empty function u8500_of_init_devices()
From: Linus Walleij <linus.walleij@linaro.org>
To: Lee Jones <lee.jones@linaro.org>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Linus WALLEIJ <linus.walleij@stericsson.com>,
        Mian Yousaf KAUKAB <mian.yousaf.kaukab@stericsson.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 5:03 PM, Lee Jones <lee.jones@linaro.org> wrote:

> As promised, now all devices which resided in u8500_of_init_devices()
> have been enabled for Device Tree, we can completely remove it.
>
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

Beautiful.
Acked-by: Linus Walleij <linus.walleij@linaro.org>

Yours,
Linus Walleij
