Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753251AbaGMKHD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 06:07:03 -0400
Received: from mail-pa0-f50.google.com ([209.85.220.50]:34732 "EHLO
	mail-pa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752526AbaGMKGx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 06:06:53 -0400
Message-ID: <53C25A36.3040207@gmail.com>
Date: Sun, 13 Jul 2014 18:06:46 +0800
From: Chen Gang <gang.chen.5i5j@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Weinberger <richard@nod.at>
CC: Lennox Wu <lennox.wu@gmail.com>, Marek Vasut <marex@denx.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        dmitry.torokhov@gmail.com, thierry.reding@gmail.com, jic23@kernel.org,
        wim@iguana.be, Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        kys@microsoft.com, Martin Schwidefsky <schwidefsky@de.ibm.com>,
        teg@jklm.no, Mischa.Jonker@synopsys.com, msalter@redhat.com,
        lars@metafoo.de, knaack.h@gmx.de, rdunlap@infradead.org,
        linux-input@vger.kernel.org, linux-pwm@vger.kernel.org,
        linux-iio@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-watchdog@vger.kernel.org, Liqin Chen <liqin.linux@gmail.com>
Subject: Re: [PATCH] drivers: Let several drivers depends on HAS_IOMEM for
 'devm_ioremap_resource'
References: <53C1F7DE.3060102@gmail.com>	<201407130545.23004.marex@denx.de> <CAF0htA60juBVkPo2HQKMDGcEr-wRzRVL_6JgHAa+7WVE_E8M0Q@mail.gmail.com> <53C25551.1050909@nod.at>
In-Reply-To: <53C25551.1050909@nod.at>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/13/2014 05:45 PM, Richard Weinberger wrote:
> Am 13.07.2014 11:27, schrieb Lennox Wu:
>> As I said before, some configurations don't make sense.
> 
> If such a configuration can be achieved using allmod/yesconfig it has to be fixed.
> Chen's fixes seem reasonable as not all architectures support iomem.
>

OK, thanks. And I shall split them into several patches, although we can
understand that score may not need them.


Thanks.
-- 
Chen Gang

Open share and attitude like air water and life which God blessed
