Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754100Ab3EXO3K (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 10:29:10 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:49560 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753178Ab3EXO3I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 10:29:08 -0400
Message-ID: <519F792E.8090109@overkiz.com>
Date: Fri, 24 May 2013 16:29:02 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Nicolas Ferre <nicolas.ferre@atmel.com>
CC: Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Joachim Eastwood <manabian@gmail.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH] ARM: at91/dt: add pinctrl definition for at91 tc blocks
References: <1369389956-30466-1-git-send-email-b.brezillon@overkiz.com> <20130524140528.GE24476@game.jcrosoft.org> <519F754F.50908@atmel.com>
In-Reply-To: <519F754F.50908@atmel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8780330424054151276
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/05/2013 16:12, Nicolas Ferre wrote:
> On 24/05/2013 16:05, Jean-Christophe PLAGNIOL-VILLARD :
>> On 12:05 Fri 24 May     , Boris BREZILLON wrote:
>>> Hello,
>>>
>>> This patch adds pinctrl configs for at91 Timer Conter blocks.
>>> These pin configs will be referenced by "atmel,tcb-pwm" devices to
>>> setup pins as PWM output.
>>
>> you need to rebase on
>>
>> a cleanup I did preset on our git tag at91-3.11-cleanup
>>
>> As we announce Mandaotory for 3.11
>>
>> as I introduce Macro fro DT
Ok, I'll base my future dt patches (kizbox.dts) on this tag.
>
> Boris, Hold on.
>
> I may have the solution for you. Give me some time and we may have the 
> automatic generation for updating your patch.
Ok, thanks.
>
> Bye,

