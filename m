Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760697AbaEMNMX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 May 2014 09:12:23 -0400
Received: from mail-ob0-f181.google.com ([209.85.214.181]:62397 "EHLO
	mail-ob0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760663AbaEMNMW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 May 2014 09:12:22 -0400
MIME-Version: 1.0
In-Reply-To: <CA+5PVA6uFueQExKVG=+u_mwQN3Bhvoy9XkxetRg4Aev1S7vdyA@mail.gmail.com>
References: <536A339D.9030606@hurleysoftware.com>
	<20140507140558.GA26294@ks3318809.kimsufi.com>
	<536A4454.5020404@hurleysoftware.com>
	<CACRpkdZ_Wz2QLbdbXEL9CWy+=tcVwjVjVqQgYw7_dy-5FwxB9Q@mail.gmail.com>
	<20140509072050.GG5767@lee--X1>
	<536CBC5E.5070202@hurleysoftware.com>
	<CA+5PVA42QVXW_=C3z=i7mvv4RBeuaX64RxuWW8-iZYi0um9big@mail.gmail.com>
	<CACRpkdbd54YLF6PMO+7fiRqe_iQ8uL3L-jH_+TG9Fpv24-PXyQ@mail.gmail.com>
	<CA+5PVA6uFueQExKVG=+u_mwQN3Bhvoy9XkxetRg4Aev1S7vdyA@mail.gmail.com>
Date: Tue, 13 May 2014 15:12:21 +0200
Message-ID: <CACRpkdafVxC-mU_D3mOCMLxRNWG2XoumdLr7i6NUm=Da3Gt_Ng@mail.gmail.com>
Subject: Re: [3.15-rc3] BUG: null ptr dereference in ichx_gpio_request_regions()
From: Linus Walleij <linus.walleij@linaro.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Peter Hurley <peter@hurleysoftware.com>, Lee Jones <lee.jones@linaro.org>,
        Vincent Donnefort <vdonnefort@gmail.com>,
        Linux kernel <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 2:50 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
> On Tue, May 13, 2014 at 5:34 AM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Fri, May 9, 2014 at 2:29 PM, Josh Boyer <jwboyer@fedoraproject.org> wrote:
>>
>>>> Hmmm. Search for '[PATCH] gpio: ich: set regs and reglen for i3100 and ich6
>>>> chipset'
>>>> (which is the bug fix for the buggy commit) turns up nothing in mainline.
>>>
>>> It's not in mainline (as you've found).
>>
>> Has this been fixed now then? *I* can see it in mainline.
>
> Not that I can see as of this morning.  I saw your pull request go to
> Linus that contains the fix, but he hasn't pulled it into mainline
> yet.  So hopefully soon.  Not sure where you're looking to already see
> it though.

Yeah well I'm confused. Hope the pull request will fix
it, maybe something was missed somehow :-/

Yours,
Linus Walleij
