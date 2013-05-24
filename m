Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760077Ab3EXIYu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 04:24:50 -0400
Received: from 4.mo2.mail-out.ovh.net ([87.98.172.75]:43454 "EHLO
	mo2.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760050Ab3EXIYp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 04:24:45 -0400
Message-ID: <519F21BA.6040403@overkiz.com>
Date: Fri, 24 May 2013 10:15:54 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: linux-kernel@vger.kernel.org, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>
X-Ovh-Mailout: 178.32.228.2 (mo2.mail-out.ovh.net)
Subject: Re: [RESEND PATCH] pwm: pwm-atmel-tcb: pinctrl support
References: <1369327132-31935-1-git-send-email-b.brezillon@overkiz.com> <20130523193545.GF17462@avionic-0098.adnet.avionic-design.de>
In-Reply-To: <20130523193545.GF17462@avionic-0098.adnet.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2478387170275325974
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiiedrtdefucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/05/2013 21:35, Thierry Reding wrote:
> On Thu, May 23, 2013 at 06:38:52PM +0200, Boris BREZILLON wrote:
>> Hello,
>>
>> I sent a patch 1 month ago to add pinctrl support to pwm-atmel-tcb
>> driver and didn't get any review.
>>
>> Could you take a look?
>>
>> This patch adds pins request for the pwm device exposed by the TC
>> block using the pinctrl subsystem.
> I was actually looking at this a few days back and thought I remembered
> this being handled in the core now. There was some discussion about this
> back in January (?) as far as I remember. I just verified that indeed
> there is code in the driver core code to do this. See commit:
>
> 	ab78029ecc347debbd737f06688d788bd9d60c1d  drivers/pinctrl: grab default handles from device core
>
> Are you sure this is really necessary in the driver?
No.

Thanks for pointing this commit out (I didn't notice the default handles 
were grabbed
from device core).

I'll test it without this patch.

Best Regards,
Boris
> Thierry

