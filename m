Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752440Ab3FJUA1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Jun 2013 16:00:27 -0400
Received: from mail-ye0-f173.google.com ([209.85.213.173]:38313 "EHLO
	mail-ye0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751638Ab3FJUA0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Jun 2013 16:00:26 -0400
X-Greylist: delayed 422 seconds by postgrey-1.27 at vger.kernel.org; Mon, 10 Jun 2013 16:00:26 EDT
Message-ID: <51B62EAD.5000601@gmail.com>
Date: Mon, 10 Jun 2013 14:53:17 -0500
From: Rob Herring <robherring2@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: Stephen Warren <swarren@wwwdotorg.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        =?ISO-8859-1?Q?Heiko_St=FC?= =?ISO-8859-1?Q?bner?= 
	<heiko@sntech.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Grant Likely <grant.likely@secretlab.ca>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Patrice Chotard <patrice.chotard.st@gmail.com>
Subject: Re: [EXAMPLE PATCH] pinctrl: add pinctrl driver for Rockchip SoCs
References: <201306090159.05383.heiko@sntech.de> <201306090201.17739.heiko@sntech.de> <CACRpkdaEcZZ3NZzwKOhUPjvFg+bSZ=UbpyPT2EBcAfVv1-EsKA@mail.gmail.com> <51B619B9.8040204@wwwdotorg.org>
In-Reply-To: <51B619B9.8040204@wwwdotorg.org>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/10/2013 01:23 PM, Stephen Warren wrote:
> On 06/10/2013 07:00 AM, Linus Walleij wrote:
>> On Sun, Jun 9, 2013 at 2:01 AM, Heiko Stübner <heiko@sntech.de> wrote:
>>
>> (...)
>>> +#include <linux/irqchip/chained_irq.h>
>>> +#include <linux/clk-provider.h>
>>> +#include <dt-bindings/pinctrl/rockchip.h>
>>
>> Hm I don't know if we're supposed to do things like this actually.
>>
>> It depends on whether the <dt-bindings/*> hierarchy is supposed
>> to stay in the kernel after the device trees are moved out to a
>> separate repo.
>>
>> Grant/Rob, shall we do this in drivers?
> 
> The entire reason I created the <dt-bindings/> directory (rather than
> just putting *.h into e.g. arch/arm/boot/dts) was to provide a place to
> share binding-defined constants between the DT files and drivers that
> implement that binding. It's certainly my opinion that if/when *.dts
> move out of the kernel, the <dt-bindings/> directory should continue to
> be present in the kernel, and take updates mirrored from the upstream
> binding repo.

Yes, agreed. Only kernel headers in a dts would be a problem.

Rob

