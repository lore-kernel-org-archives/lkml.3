Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755043Ab3HALG2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 07:06:28 -0400
Received: from 1.mo2.mail-out.ovh.net ([46.105.63.121]:35692 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1754658Ab3HALG1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 07:06:27 -0400
X-Greylist: delayed 16766 seconds by postgrey-1.27 at vger.kernel.org; Thu, 01 Aug 2013 07:06:26 EDT
Message-ID: <51FA412C.9080900@overkiz.com>
Date: Thu, 01 Aug 2013 13:06:20 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        Mark Brown <broonie@kernel.org>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 0/8] ARM: at91/dt: make use of periph id macros
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com> <CACQ1gAj_KCJUnBGzv0bnGaUwMgWq-7Noe280YdLGPxK8Ofp3Bw@mail.gmail.com> <CACQ1gAjQ4raVHbMUfPZM=BQ-+SCbOJvxmR_5Vh=xpX592MZo7A@mail.gmail.com>
In-Reply-To: <CACQ1gAjQ4raVHbMUfPZM=BQ-+SCbOJvxmR_5Vh=xpX592MZo7A@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 4768467581479844005
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedtucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

On 01/08/2013 11:27, Richard Genoud wrote:
> 2013/8/1 Richard Genoud <richard.genoud@gmail.com>:
>> 2013/8/1 Boris BREZILLON <b.brezillon@overkiz.com>:
>>> Hello,
>>>
>>> This patch series move at91 SoCs peripheral id definitions from machine
>>> specific include dir to dt-bindings include dir.
>>> These macros are used to reference interrupts instead of peripheral numbers.
>>>
>>> This makes dt definitions cleaner and easier to debug (one can easily tell if
>>> the peripheral macro used to reference an interrupt line is not the good one).
>>>
>>> These macros will be used for clk definitions and references too.
>>>
>>> I am not sure 'include/dt-bindings/at91/xxx' is the best place to put these
>>> definitions as there are no soc specific directories in dt-bindings include
>>> dir right now. Maybe something like 'include/dt-bindings/soc/at91/xxx' or
>>> 'include/dt-bindings/peripherals/at91/xxx' would be better.
>>> What do you think ?
>> Well, I'd rather use "atmel" than "at91" because, AFAIK, this prefix
>> has been dropped for new atmel SoCs (sama5 for instance).

Sure, I will replace at91 by atmel, but I'd like to get some feedback 
from at91
maintainers before doing this.

Could devicetree maintainers take a look at this series too ?
I don't want to mess with dt-bindings include directory by adding some 
files at
the wrong place...

> [changed Mark Brown address from opensource.wolfsonmicro.com to
> kernel.org (the 1st one failed)]

Sorry Mark. Do you want me to resend you the whole series ?

>
> The whole serie seems good to me (add adding the missing defines is great).
>
> You can add my:
> Reviewed-by: Richard Genoud <richard.genoud@gmail.com>
> on the whole serie.
>
> and my
> Tested-by: Richard Genoud <richard.genoud@gmail.com>
> on patch 7/8
>
>
> Richard.

Thanks for the review and the tests.

Best Regards,

Boris
