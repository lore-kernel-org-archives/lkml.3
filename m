Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003Ab3LBRUV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 12:20:21 -0500
Received: from mail-qa0-f46.google.com ([209.85.216.46]:55198 "EHLO
	mail-qa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752886Ab3LBRUR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 12:20:17 -0500
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <1385991521-3934-1-git-send-email-nicolas.ferre@atmel.com>
References: <1385991521-3934-1-git-send-email-nicolas.ferre@atmel.com>
Date: Mon, 2 Dec 2013 09:20:15 -0800
Message-ID: <CAOesGMjbj6kRosx_ToQ64nkaz_XNUs53Q9ScZeGk0BO6wWw1Hg@mail.gmail.com>
Subject: Re: [GIT PULL] at91: fixes 3.13 #2
From: Olof Johansson <olof@lixom.net>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Arnd Bergmann <arnd@arndb.de>, "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>, motobud@gmail.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 2, 2013 at 5:38 AM, Nicolas Ferre <nicolas.ferre@atmel.com> wrote:
> Arnd, Olof, Kevin,
>
> A second round of fixes for 3.13 on top of 3.13-rc1. The main fix of this
> series is the one that reduces the frequency of the i2c IP and avoid to hit
> some nasty hardware bugs. It actually allows to save a little power as well...
>
> Thanks, best regards,
>
> The following changes since commit 6ce4eac1f600b34f2f7f58f9cd8f0503d79e42ae:
>
>   Linux 3.13-rc1 (2013-11-22 11:30:55 -0800)
>
> are available in the git repository at:
>
>   git://github.com/at91linux/linux-at91.git tags/at91-fixes
>
> for you to fetch changes up to 7093bf2b7195541281cb711e31c027a8d826c6df:
>
>   ARM: at91: fixed unresolved symbol "at91_pm_set_standby" when built without CONFIG_PM (2013-12-02 14:24:40 +0100)

Pulled. Thanks for making sure the patch descriptions are good.


-Olof
