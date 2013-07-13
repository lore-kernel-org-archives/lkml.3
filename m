Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964778Ab3GMObF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 10:31:05 -0400
Received: from mail-lb0-f181.google.com ([209.85.217.181]:36314 "EHLO
	mail-lb0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932571Ab3GMObD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 10:31:03 -0400
MIME-Version: 1.0
In-Reply-To: <CAN1soZzQz8PaHOwNf-Ec6G=ahhx_P8gaaX4fQnpX-Mqrepk_7g@mail.gmail.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-2-git-send-email-zhangwm@marvell.com>
	<20130709124900.GG11908@titan.lakedaemon.net>
	<CAN1soZxiOh6TpbUOCUzK8gNwmvjbT3ihkUWaw8tuZ7md+NVA2g@mail.gmail.com>
	<20130710122433.GO11908@titan.lakedaemon.net>
	<CAN1soZzMvront1-jcBW6-uRKNs0OZNGnmiOjKGZSM28bViB_8A@mail.gmail.com>
	<20130710215041.GR11908@titan.lakedaemon.net>
	<CAN1soZzuiukY9qASFNcH0k=zH8=uT=71bKejPss44FCzNy=X-A@mail.gmail.com>
	<CAMLZHHQGZvDssY-YxQ3ZW8FYhpG-H1-VbokOid33socRSPrMNw@mail.gmail.com>
	<CAN1soZzQz8PaHOwNf-Ec6G=ahhx_P8gaaX4fQnpX-Mqrepk_7g@mail.gmail.com>
Date: Sat, 13 Jul 2013 08:30:59 -0600
X-Google-Sender-Auth: ne0Uewe56YB_jsXY4OAiL6I6xLA
Message-ID: <CAMLZHHSDu+zgumVtWeU8yGiJ8Wmp3TQJbEc6u54LziOC5oXPeQ@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
From: Daniel Drake <dsd@laptop.org>
To: Haojian Zhuang <haojian.zhuang@gmail.com>
Cc: Jason Cooper <jason@lakedaemon.net>, Bergmann Arnd <arnd@arndb.de>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Neil Zhang <zhangwm@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 6:35 PM, Haojian Zhuang
<haojian.zhuang@gmail.com> wrote:
> These patches couldn't be applied. Since we're moving irq drivers from arch
> directories to irq directories.

It does not seem in line with the collaborative manner of kernel
development to block my patches for a whole month because they
conflict with your own private patches which do not exist for anyone
else (at least I searched and couldn't find them).

Please, either post your patches immediately (I will help review), or
review mine and figure out how to handle any conflict with your own
work afterwards.

> When the irq patches are applied, you can rebase your patches.

2 of the pending patches don't touch the irq stuff anyway.

Daniel
