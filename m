Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752243AbaIYISc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 04:18:32 -0400
Received: from mail-ie0-f175.google.com ([209.85.223.175]:56066 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751160AbaIYIS3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 04:18:29 -0400
MIME-Version: 1.0
In-Reply-To: <54230B9C.9090703@converseincode.com>
References: <20140923212922.GG12270@beef>
	<1411512908-19237-1-git-send-email-behanw@converseincode.com>
	<1411512908-19237-2-git-send-email-behanw@converseincode.com>
	<5774775.2EcFmuR4sV@wuerfel>
	<54230B9C.9090703@converseincode.com>
Date: Thu, 25 Sep 2014 10:18:28 +0200
Message-ID: <CACRpkdYR25dswGSd+qc8rSG=F8qL6jf6=BJdMVJXfzFV3cvsnQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] mmc, sdhci, bcm-kona, LLVMLinux: Remove use of __initconst
From: Linus Walleij <linus.walleij@linaro.org>
To: Behan Webster <behanw@converseincode.com>
Cc: Arnd Bergmann <arnd@arndb.de>, Christian Daudt <bcm@fixthebug.org>,
        Chris Ball <chris@printf.net>, Alexandre Courbot <gnurou@gmail.com>,
        Matt Porter <mporter@linaro.org>, Ulf Hansson <ulf.hansson@linaro.org>,
        bcm-kernel-feedback-list <bcm-kernel-feedback-list@broadcom.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-mmc@vger.kernel.org" <linux-mmc@vger.kernel.org>,
        Ray Jui <rjui@broadcom.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Sep 24, 2014 at 8:21 PM, Behan Webster
<behanw@converseincode.com> wrote:
> On 09/24/14 02:22, Arnd Bergmann wrote:
>>   but the first one seems
>> easier to read for someone familiar with kernel code.
>
> No worries. Happy to post a v3.
>
> Linus Walleij: Would you like me to respin the "gpio, bcm-kona, LLVMLinux:
> Remove use of __initconst" patch as well?

No it's already applied.

Yours,
Linus Walleij
