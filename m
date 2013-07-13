Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757962Ab3GMAfH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:35:07 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:42032 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757941Ab3GMAfF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:35:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAMLZHHQGZvDssY-YxQ3ZW8FYhpG-H1-VbokOid33socRSPrMNw@mail.gmail.com>
References: <1373352166-10064-1-git-send-email-zhangwm@marvell.com>
	<1373352166-10064-2-git-send-email-zhangwm@marvell.com>
	<20130709124900.GG11908@titan.lakedaemon.net>
	<CAN1soZxiOh6TpbUOCUzK8gNwmvjbT3ihkUWaw8tuZ7md+NVA2g@mail.gmail.com>
	<20130710122433.GO11908@titan.lakedaemon.net>
	<CAN1soZzMvront1-jcBW6-uRKNs0OZNGnmiOjKGZSM28bViB_8A@mail.gmail.com>
	<20130710215041.GR11908@titan.lakedaemon.net>
	<CAN1soZzuiukY9qASFNcH0k=zH8=uT=71bKejPss44FCzNy=X-A@mail.gmail.com>
	<CAMLZHHQGZvDssY-YxQ3ZW8FYhpG-H1-VbokOid33socRSPrMNw@mail.gmail.com>
Date: Sat, 13 Jul 2013 08:35:03 +0800
Message-ID: <CAN1soZzQz8PaHOwNf-Ec6G=ahhx_P8gaaX4fQnpX-Mqrepk_7g@mail.gmail.com>
Subject: Re: [PATCH V3 1/3] dts: change Marvell prefix to 'marvell'
From: Haojian Zhuang <haojian.zhuang@gmail.com>
To: Daniel Drake <dsd@laptop.org>
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

On Fri, Jul 12, 2013 at 11:10 PM, Daniel Drake <dsd@laptop.org> wrote:
> On Thu, Jul 11, 2013 at 5:54 PM, Haojian Zhuang
> <haojian.zhuang@gmail.com> wrote:
>>> Well, Daniel Drake spoke up for OLPC.  Does that count?
>>
>> We don't know they used DT on Marvell MMP2/MMP3. So they don't have DTS file
>> in kernel, we could use both old name & new name in driver.
>
> You are listed as one of the MMP maintainers in the MAINTAINERS file
> and I have sent you several patches in the few 3 weeks which make
> OLPC's usage of MMP + DT pretty obvious. As a maintainer I believe you
> are supposed to review the patches too. hint hint ;)
>

These patches couldn't be applied. Since we're moving irq drivers from arch
directories to irq directories.

When the irq patches are applied, you can rebase your patches.

Regards
Haojian
