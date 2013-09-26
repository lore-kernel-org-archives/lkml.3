Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751033Ab3IZEL6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 00:11:58 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:47912 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750811Ab3IZEL5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 00:11:57 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1380027682-8132-1-git-send-email-nicolas.ferre@atmel.com>
References: <1380027682-8132-1-git-send-email-nicolas.ferre@atmel.com>
Date: Wed, 25 Sep 2013 21:11:56 -0700
Message-ID: <CAOesGMjDXFJy3FRRUuFH2EXdwcELYAweqckZfTLrOqEvDoefAw@mail.gmail.com>
Subject: Re: [GIT PULL] at91: fixes for 3.12 #1
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        Linux Kernel list <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 24, 2013 at 6:01 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof, Kevin,
>
> This is the first batch of fixes for AT91.
> I think that the removal of the void flag IRQF_DISABLED can be schedulled in
> this timeframe as we are pretty early in the cycle and that this patch
> shouldn't wait more.

Those patches have been trickling in, and I'm not sure if all
maintainers are picking them up for 3.12.

Anyway, it's still fairly early and it's a tiny patch.

>
> Thanks, best regards,
>
> The following changes since commit 272b98c6455f00884f0350f775c5342358ebb73f:
>
>   Linux 3.12-rc1 (2013-09-16 16:17:51 -0400)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes

Pulled, thanks.

-Olof
