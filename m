Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751946Ab3LLVWK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 16:22:10 -0500
Received: from mail-wi0-f171.google.com ([209.85.212.171]:36653 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703Ab3LLVWG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 16:22:06 -0500
MIME-Version: 1.0
In-Reply-To: <CACRpkdbGSXA8oT8L-0fzJx7esXn7GWQA+Wi7WCQKX9eiy-fYCQ@mail.gmail.com>
References: <1386825152-398-1-git-send-email-panchaxari.prasannamurthy@linaro.org>
	<26167386.hX5eWUjT6T@flatron>
	<CACRpkdbGSXA8oT8L-0fzJx7esXn7GWQA+Wi7WCQKX9eiy-fYCQ@mail.gmail.com>
Date: Thu, 12 Dec 2013 22:22:02 +0100
Message-ID: <CA+Ln22EaSpzrSaW-TC1BMhnj8aPZMfK9pCTqBMnGXC3B-06FBQ@mail.gmail.com>
Subject: Re: [PATCH CFT] ARM:S5P64X0: Enable ARM_PATCH_PHYS_VIRT and
 AUTO_ZRELADDR by default
From: Tomasz Figa <tomasz.figa@gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Mark Brown <broonie@kernel.org>,
        panchaxari <panchaxari.prasannamurthy@linaro.org>,
        Kgene Kim <kgene.kim@samsung.com>, Patch Tracking <patches@linaro.org>,
        linaro-kernel <linaro-kernel@lists.linaro.org>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Heiko Stuebner <heiko@sntech.de>,
        Russell King <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/12 Linus Walleij <linus.walleij@linaro.org>:
> On Thu, Dec 12, 2013 at 10:47 AM, Tomasz Figa <tomasz.figa@gmail.com> wrote:
>
>> This is actually quite a poor platform choice. As of today, the kernel
>> is stuck with supporting just SMDK6440/6450 boards, which are proprietary
>> development boards and it doesn't look like any further boards will show
>> up in future. Kukjin has actually proposed removing support for this
>> platform at all and I consider this reasonable.
>>
>> Kukjin, should we proceed with removal?
>
> Isn't Mark Brown using that platform for some various stuff?

Not as far as I know.

He's using Cragganmore board based on s3c6410, but this is a different
platform (s3c64xx).

Best regards,
Tomasz
