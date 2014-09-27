Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752785AbaI0MuX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 08:50:23 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:42962 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaI0MuV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 08:50:21 -0400
Message-ID: <5426B289.7070802@gmail.com>
Date: Sat, 27 Sep 2014 14:50:17 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.1
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Subject: Re: [PATCH 0/5] pinctrl: samsung: Data structure clean-up
References: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com> <CACRpkdZCMD4x+wrvTOrrWK-Dy4_rg6bD2xUAA4jtTGTbT1uDag@mail.gmail.com> <5423C904.60708@gmail.com>
In-Reply-To: <5423C904.60708@gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

On 25.09.2014 09:49, Tomasz Figa wrote:
> On 25.09.2014 09:47, Linus Walleij wrote:
>> On Tue, Sep 23, 2014 at 9:05 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>>
>>> This series intends to clean up data structures used by pinctrl-samsung driver.
>>> More specifically, it separates initial compile time constants from data used
>>> at runtime, allowing unused variant data to be dropped and selected structures
>>> constified to improve safety.
>>
>> I like the patch set, tried to apply it but patch 3/5 failed to apply to the
>> devel branch for pinctrl.
>>
>> Can you rebase this on my "devel" branch, include Marek's Tested-by
>> tag and resend, and I'll take it for v3.18.
> 
> Sure. Will do that today evening. Probably clashed with some other
> changes queued in the meantime.

Uhm. I went back home and forgot about this series until now. Sorry.

I have rebased it on your "devel" branch, although it seems like this
branch is missing [1], which in turn seems to be already present in your
"for-next" branch and is going to cause a merge conflict with this
series. Should I still proceed with posting the series based on "devel"?

[1] f6a8249f9e55d pinctrl: exynos: Lock GPIOs as interrupts when used as
EINTs

Best regards,
Tomasz
