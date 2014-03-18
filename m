Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754743AbaCRIho (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 04:37:44 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:51318 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754566AbaCRIhk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 04:37:40 -0400
Message-ID: <532805AE.9000806@ti.com>
Date: Tue, 18 Mar 2014 14:07:02 +0530
From: Sekhar Nori <nsekhar@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Alexandre Courbot <gnurou@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>,
        Rob Herring <robh+dt@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Alexander Holler <holler@ahsoftware.de>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
References: <5316FFCE.1060603@ti.com> <1394018461-757-1-git-send-email-holler@ahsoftware.de> <CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com> <5322D529.4070904@ahsoftware.de> <CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com> <5326F8C5.5090406@ti.com> <CACRpkdYZMzw31NkA4uSq+ZowzOnZgZthXhZri-eJY2Ozb8aNRQ@mail.gmail.com>
In-Reply-To: <CACRpkdYZMzw31NkA4uSq+ZowzOnZgZthXhZri-eJY2Ozb8aNRQ@mail.gmail.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday 17 March 2014 07:35 PM, Linus Walleij wrote:
> On Mon, Mar 17, 2014 at 2:29 PM, Sekhar Nori <nsekhar@ti.com> wrote:
> 
>> One thing to note is that this driver is used by keystone too and all
>> its users are DT-only. Although I do not see any in-kernel DT GPIO users
>> even there.
>>
>> I can confirm the patch does not break my gpiolib based test module
>> (test with and without DT), but then it did not have an issue even before.
> 
> Is that a Tested-by tag? :-)

Yes.

Tested-by: Sekhar Nori <nsekhar@ti.com>

> 
> If you're also convinced that fix is safe I'll push it as a fix to v3.14-rcN
> if for nothing else so for getting Mr. Holler to stop poking me in the
> chest.

It is safe - at the least it does not break anything that is already
working. I guess the decision to put it into -rc depends on whether you
consider out of tree dtbs to be a valid usecase for the kernel.

Thanks,
Sekhar
