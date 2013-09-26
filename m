Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751362Ab3IZFCo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 26 Sep 2013 01:02:44 -0400
Received: from mail-qe0-f44.google.com ([209.85.128.44]:59685 "EHLO
	mail-qe0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751217Ab3IZFCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 26 Sep 2013 01:02:43 -0400
MIME-Version: 1.0
X-Originating-IP: [173.13.129.225]
In-Reply-To: <CACRpkdZ5G02w9JivgfVW4LvGe35=uCD+ROLC0+iL4HzFaAh9ng@mail.gmail.com>
References: <1380103893-7119-1-git-send-email-joro@8bytes.org>
	<CACRpkdZ5G02w9JivgfVW4LvGe35=uCD+ROLC0+iL4HzFaAh9ng@mail.gmail.com>
Date: Wed, 25 Sep 2013 22:02:42 -0700
Message-ID: <CAOesGMjFi8BdcYT7rswcAyvYVqJxBZeFNOEO8EJhj9uEp-wKGQ@mail.gmail.com>
Subject: Re: [PATCH] arm: mach-integrator: Add stub for pci_v3_early_init()
 for !CONFIG_PCI
From: Olof Johansson <olof@lixom.net>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Joerg Roedel <joro@8bytes.org>, "arm@kernel.org" <arm@kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Arnd Bergmann <arnd@arndb.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        stable <stable@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 25, 2013 at 6:39 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
> On Wed, Sep 25, 2013 at 12:11 PM, Joerg Roedel <joro@8bytes.org> wrote:
>
>> This fixes a compile error where CONFIG_PCI is disabled:
>
> ARM SoC folks, can you please apply this directly for fixes?

Done!

Thanks,

-Olof
