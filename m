Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756250AbaCNSde (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Mar 2014 14:33:34 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:59573 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755111AbaCNSdc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Mar 2014 14:33:32 -0400
Message-ID: <53234B68.5090300@ahsoftware.de>
Date: Fri, 14 Mar 2014 19:33:12 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "davinci-linux-open-source@linux.davincidsp.com" 
	<davinci-linux-open-source@linux.davincidsp.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Sekhar Nori <nsekhar@ti.com>,
        Prabhakar Lad <prabhakar.csengg@gmail.com>
Subject: Re: [PATCH v2] gpio: davinci: fix gpio selection for OF
References: <5316FFCE.1060603@ti.com>	<1394018461-757-1-git-send-email-holler@ahsoftware.de>	<CACRpkdaF=jc9Z1XZCtH8VPuih01t--qyV-sgH1R_ix0VM4RzVA@mail.gmail.com>	<5322D529.4070904@ahsoftware.de>	<CACRpkdaghneo1MvNCfxjTED+sJepHgeZCgmKsRteG9qrBNWAfQ@mail.gmail.com>	<5322F82A.9000507@ahsoftware.de> <CACRpkdZscprsy7kyqHPUMEMYJ_TKgG2bYR7mdrG4hTDp1w1nDg@mail.gmail.com>
In-Reply-To: <CACRpkdZscprsy7kyqHPUMEMYJ_TKgG2bYR7mdrG4hTDp1w1nDg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.03.2014 14:54, schrieb Linus Walleij:
> On Fri, Mar 14, 2014 at 1:38 PM, Alexander Holler <holler@ahsoftware.de> wrote:
>
>>> In that case it is hardly a fix that we need to rush out to the entire
>>> world.
>>
>> And I thought the reason for -rc is actually to fix bugs. But I never
>> understood the magical ways and timings patches make their way into
>> mainline. ;)
>
> OK so it works like this: early in the -rc cycle we fix any bugs, documentation
> or whatever. At this point it's *regressions* so the fix need to fix something
> that broke in the merge window (or an earlier merge window).

Sorry, but I don't believe that. It's always time to fix regressions and 
bugs.

> If it is a new feature that never worked in the first place I would
> not call that
> a regression. There are no existing users out there that can experience
> regressions from a previously working system.

I believe that no (stable) kernel should introduce new known bugs (if 
fixes are available) and I wouldn't make a difference if it's a new 
feature or not. Usually people don't care if something is new or not if 
it has bugs

Anyway, I'm just curious and try to understand, I have a fix. ;)

Regards,

Alexander Holler
