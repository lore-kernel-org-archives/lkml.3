Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755620Ab3KEV71 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 16:59:27 -0500
Received: from mail-vc0-f174.google.com ([209.85.220.174]:63438 "EHLO
	mail-vc0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755271Ab3KEV7Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 16:59:25 -0500
MIME-Version: 1.0
In-Reply-To: <001101ced6a8$a18a2c80$e49e8580$%han@samsung.com>
References: <CAPgLHd8V06KzBcPmFywSfNxM0q6=s86xn-AdLKeY9h5JZ_nP7g@mail.gmail.com>
	<001101ced6a8$a18a2c80$e49e8580$%han@samsung.com>
Date: Tue, 5 Nov 2013 13:59:25 -0800
Message-ID: <CAN8TOE9Eac0LDA+Ke_OCPc_AQGnyYB806pO8JP-qOB1Dr8N2pg@mail.gmail.com>
Subject: Re: [PATCH -next] mtd: nand: omap: fix error return code in omap_nand_probe()
From: Brian Norris <computersforpeace@gmail.com>
To: Jingoo Han <jg1.han@samsung.com>, "Gupta, Pekon" <pekon@ti.com>
Cc: Wei Yongjun <weiyj.lk@gmail.com>, David Woodhouse <dwmw2@infradead.org>,
        Daniel Mack <zonque@gmail.com>, avinashphilip@ti.com,
        Artem Bityutskiy <artem.bityutskiy@linux.intel.com>,
        "tony@atomide.com" <tony@atomide.com>, yongjun_wei@trendmicro.com.cn,
        "linux-mtd@lists.infradead.org" <linux-mtd@lists.infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 31, 2013 at 7:18 PM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Friday, November 01, 2013 9:16 AM, Wei Yongjun wrote:
>>
>> From: Wei Yongjun <yongjun_wei@trendmicro.com.cn>
>>
>> Fix to return a negative error code from the error handling
>> case instead of 0, as done elsewhere in this function.
>
> Commit message is right? :-(

It sounds OK by my reading. Unless you're having trouble parsing what
"as done elsewhere in this function" is being applied to. (IOW, is the
rest of the function returning a negative error code on the error
paths, or is it returning 0? Of course the answer is the former, but
it's possible to misread it.) If it helps, I can try to tweak the
wording a bit when applying this patch.

Pekon, can I get an Acked-by?

Thanks,
Brian
