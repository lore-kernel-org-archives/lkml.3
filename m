Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752137AbaJKJEd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 11 Oct 2014 05:04:33 -0400
Received: from mail-vc0-f180.google.com ([209.85.220.180]:63884 "EHLO
	mail-vc0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751570AbaJKJEc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 11 Oct 2014 05:04:32 -0400
MIME-Version: 1.0
In-Reply-To: <5438EFAF.4020303@huawei.com>
References: <5438EFAF.4020303@huawei.com>
Date: Sat, 11 Oct 2014 11:04:30 +0200
Message-ID: <CAFLxGvzOnEbNYn1ovXL+e6pwk=+bVfWXsSoEWq9R2+O1Amu5rA@mail.gmail.com>
Subject: Re: Memory trample when using /dev/mem
From: Richard Weinberger <richard.weinberger@gmail.com>
To: Hu Keping <hukeping@huawei.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Greg KH <gregkh@linuxfoundation.org>,
        LKML <linux-kernel@vger.kernel.org>, sdu.liu@huawei.com,
        wangnan0@huawei.com, peifeiyue@huawei.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Oct 11, 2014 at 10:51 AM, Hu Keping <hukeping@huawei.com> wrote:
> As there are many drivers using /dev/mem and we can not
> make sure that the different task will not trample on
> each others memory.Shall we add some printk to help locating the problem
> when error happened?

Actually no driver should use /dev/mem.
Please have a look at UIO.

-- 
Thanks,
//richard
