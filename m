Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752352AbaEVV4Z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 17:56:25 -0400
Received: from mail-oa0-f48.google.com ([209.85.219.48]:44435 "EHLO
	mail-oa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751424AbaEVV4Y convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 17:56:24 -0400
MIME-Version: 1.0
In-Reply-To: <20140516164751.GA8406@kwain>
References: <1399267649-20218-1-git-send-email-antoine.tenart@free-electrons.com>
	<1399267649-20218-7-git-send-email-antoine.tenart@free-electrons.com>
	<CACRpkdaL9tzfUrY=wLjSR3dcD7JC1mUX3kdG+Wh5gDyxGY2Yqw@mail.gmail.com>
	<20140516164751.GA8406@kwain>
Date: Thu, 22 May 2014 23:56:23 +0200
Message-ID: <CACRpkdbJvasUR2+gvLSCF=grgkofs-BaOFEzK1pE212LvVj1tA@mail.gmail.com>
Subject: Re: [PATCH v3 6/7] Documentation: add the Marvell Berlin pinctrl documentation
From: Linus Walleij <linus.walleij@linaro.org>
To: =?UTF-8?Q?Antoine_T=C3=A9nart?= <antoine.tenart@free-electrons.com>
Cc: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        zhiming Xu <zmxu@marvell.com>, Jisheng Zhang <jszhang@marvell.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 16, 2014 at 6:47 PM, Antoine Ténart
<antoine.tenart@free-electrons.com> wrote:
> Linus,

>> > +sm_pinctrl: pin-controller@0 {
>> > +       compatible = "marvell,berlin2q-sysmgr-pinctrl";
>> > +       reg = <0xfc0000 0x44>;
>> > +
>> > +       uart0_pmux: uart0-pmux {
>> > +               marvell,groups = "GSM12", "GSM13";
>> > +               marvell,function = "uart0";
>> > +       };
>> > +}
>>
>> I feel like ... can't we just standardize that and make it a common
>> pinctrl binding, and name the properties "groups" and "function"
>> for a family of pin controllers just mapping N groups to 1 function?
>>
>> I will merge the patches as are, but maybe we can make it generic
>> on top of this before the merge window?
>
> Do you mean just changing:
>
> s/marvell,groups/groups/
> s/marvell,function/function/
>
> and updating the documentation ?

To the pinctrl.txt document as generic bindings.
Documentation/devicetree/bindings/pinctrl/pinctrl-bindings.txt

That and maybe moving some of the parsing into the pinctrl-utils.

> If so, I can definitely do that.

No big deal, we're a bit late on it. But if you like the looks of it,
please send a patch like that.

Yours,
Linus Walleij
