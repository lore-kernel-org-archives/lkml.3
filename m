Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752180AbaIYHta (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 03:49:30 -0400
Received: from mail-wi0-f178.google.com ([209.85.212.178]:54070 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750940AbaIYHt2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 03:49:28 -0400
Message-ID: <5423C904.60708@gmail.com>
Date: Thu, 25 Sep 2014 09:49:24 +0200
From: Tomasz Figa <tomasz.figa@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.1.0
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
References: <1411499141-26551-1-git-send-email-tomasz.figa@gmail.com> <CACRpkdZCMD4x+wrvTOrrWK-Dy4_rg6bD2xUAA4jtTGTbT1uDag@mail.gmail.com>
In-Reply-To: <CACRpkdZCMD4x+wrvTOrrWK-Dy4_rg6bD2xUAA4jtTGTbT1uDag@mail.gmail.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 25.09.2014 09:47, Linus Walleij wrote:
> On Tue, Sep 23, 2014 at 9:05 PM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
> 
>> This series intends to clean up data structures used by pinctrl-samsung driver.
>> More specifically, it separates initial compile time constants from data used
>> at runtime, allowing unused variant data to be dropped and selected structures
>> constified to improve safety.
> 
> I like the patch set, tried to apply it but patch 3/5 failed to apply to the
> devel branch for pinctrl.
> 
> Can you rebase this on my "devel" branch, include Marek's Tested-by
> tag and resend, and I'll take it for v3.18.

Sure. Will do that today evening. Probably clashed with some other
changes queued in the meantime.

Best regards,
Tomasz
