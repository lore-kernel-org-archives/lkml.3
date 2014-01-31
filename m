Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754092AbaAaKWv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 05:22:51 -0500
Received: from mail-ea0-f169.google.com ([209.85.215.169]:45461 "EHLO
	mail-ea0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751411AbaAaKWu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 05:22:50 -0500
Message-ID: <52EB796F.9000109@gmail.com>
Date: Fri, 31 Jan 2014 11:22:39 +0100
From: Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Jason Cooper <jason@lakedaemon.net>, Andrew Lunn <andrew@lunn.ch>,
        Gregory Clement <gregory.clement@free-electrons.com>,
        Thomas Petazzoni <thomas.petazzoni@free-electrons.com>,
        Russell King <linux@arm.linux.org.uk>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 00/21] pinctrl: mvebu: restructure and remove hardcoded
 addresses from Dove pinctrl
References: <1390674856-4993-1-git-send-email-sebastian.hesselbarth@gmail.com> <1390869573-27624-1-git-send-email-sebastian.hesselbarth@gmail.com> <CACRpkda5HRxpLWWizT_58SJ6Fb=TQpO=Y5yFThpZkUbUYmU8fg@mail.gmail.com>
In-Reply-To: <CACRpkda5HRxpLWWizT_58SJ6Fb=TQpO=Y5yFThpZkUbUYmU8fg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/31/14 11:17, Linus Walleij wrote:
> On Tue, Jan 28, 2014 at 1:39 AM, Sebastian Hesselbarth
> <sebastian.hesselbarth@gmail.com> wrote:
>
>> This patch set is one required step for Dove to hop into mach-mvebu.
>> Until now, pinctrl-dove was hardcoding some registers that do not
>> directly belong to MPP core registers. This is not compatible with
>> what we want for mach-mvebu.
>
> All this stuff is really nice, so if you can get Thomas to add his
> review-tag on this stuff and maybe have some Tested-by:s
> from other parties, I'd be happy to pull the end result to the
> pinctrl tree, or alternatively provide my ACK for you to take this
> through ARM SoC.

Luckily, we have a "pinctrl/mvebu" subfolder these patches will mess
with. I think it will be better to keep then all together and take
them through the MVEBU branch. This way we can have an eye on it and 
base off subsequent patches without bothering you.

I'll come back to request your ACK as soon as we have sorted it out.

Sebastian

