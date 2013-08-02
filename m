Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758169Ab3HBJFB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 05:05:01 -0400
Received: from 6.mo2.mail-out.ovh.net ([87.98.165.38]:41848 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1758081Ab3HBJE6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 05:04:58 -0400
Message-ID: <51FB7634.3080302@overkiz.com>
Date: Fri, 02 Aug 2013 11:04:52 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Richard Genoud <richard.genoud@gmail.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Russell King <linux@arm.linux.org.uk>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [PATCH 0/8] ARM: at91/dt: make use of periph id macros
References: <1375339733-3488-1-git-send-email-b.brezillon@overkiz.com> <CACQ1gAj_KCJUnBGzv0bnGaUwMgWq-7Noe280YdLGPxK8Ofp3Bw@mail.gmail.com>
In-Reply-To: <CACQ1gAj_KCJUnBGzv0bnGaUwMgWq-7Noe280YdLGPxK8Ofp3Bw@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 8590053339551004837
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeijedriedvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Richard,

On 01/08/2013 09:37, Richard Genoud wrote:
> 2013/8/1 Boris BREZILLON <b.brezillon@overkiz.com>:
>> Hello,
>>
>> This patch series move at91 SoCs peripheral id definitions from machine
>> specific include dir to dt-bindings include dir.
>> These macros are used to reference interrupts instead of peripheral numbers.
>>
>> This makes dt definitions cleaner and easier to debug (one can easily tell if
>> the peripheral macro used to reference an interrupt line is not the good one).
>>
>> These macros will be used for clk definitions and references too.
>>
>> I am not sure 'include/dt-bindings/at91/xxx' is the best place to put these
>> definitions as there are no soc specific directories in dt-bindings include
>> dir right now. Maybe something like 'include/dt-bindings/soc/at91/xxx' or
>> 'include/dt-bindings/peripherals/at91/xxx' would be better.
>> What do you think ?
> Well, I'd rather use "atmel" than "at91" because, AFAIK, this prefix
> has been dropped for new atmel SoCs (sama5 for instance).

Should I do the same for at91 clk series (replace drivers/clk/at91 directory
by drivers/clk/atmel and include/linux/clk/at91_pmc.h by
include/linux/clk/atmel_pmc.h) ?

>
> my 2 cents...
>
> Richard.

Best Regards,

Boris
