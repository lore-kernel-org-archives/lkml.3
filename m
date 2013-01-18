Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754018Ab3ARPQ6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 10:16:58 -0500
Received: from mail-ia0-f181.google.com ([209.85.210.181]:43674 "EHLO
	mail-ia0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751374Ab3ARPQ5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 10:16:57 -0500
MIME-Version: 1.0
In-Reply-To: <1357681398-23956-2-git-send-email-maxime.ripard@free-electrons.com>
References: <1357681398-23956-1-git-send-email-maxime.ripard@free-electrons.com>
	<1357681398-23956-2-git-send-email-maxime.ripard@free-electrons.com>
Date: Fri, 18 Jan 2013 16:16:56 +0100
Message-ID: <CACRpkdZYxO10yq7y3QyFHxKuS44AuT73wTfVH=4BcAq=GsKG7g@mail.gmail.com>
Subject: Re: [PATCH 1/7] pinctrl: pinconf-generic: add drive strength parameter
From: Linus Walleij <linus.walleij@linaro.org>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Olof Johansson <olof@lixom.net>,
        linux-arm-kernel@lists.infradead.org, Stefan Roese <sr@denx.de>,
        Alejandro Mery <amery@geeks.cl>, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 8, 2013 at 10:43 PM, Maxime Ripard
<maxime.ripard@free-electrons.com> wrote:

> Some pin configurations IP allows to set the current output to the pin.
> This patch adds such a parameter to the pinconf-generic mechanism.
>
> This parameter takes as argument the drive strength in mA.
>
> Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>

Patch applied!

Thanks,
Linus Walleij
