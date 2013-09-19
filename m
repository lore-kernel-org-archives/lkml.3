Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753959Ab3ISMLI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Sep 2013 08:11:08 -0400
Received: from 14.mo4.mail-out.ovh.net ([46.105.40.29]:36353 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752033Ab3ISMLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Sep 2013 08:11:06 -0400
Message-ID: <523AE9D5.6040103@overkiz.com>
Date: Thu, 19 Sep 2013 14:11:01 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: Nicolas Ferre <nicolas.ferre@atmel.com>, linux-pwm@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH 0/2] pwm: atmel-tcb: config fixes
References: <1379516720-23289-1-git-send-email-b.brezillon@overkiz.com> <20130919120616.GG10852@ulmo>
In-Reply-To: <20130919120616.GG10852@ulmo>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 16849655057071110278
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrtdduucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 19/09/2013 14:06, Thierry Reding wrote:
> On Wed, Sep 18, 2013 at 05:05:20PM +0200, Boris BREZILLON wrote:
>> Hello,
>>
>> This patch series fix 2 bugs regarding the pwm configuration:
>>   - the clock source of the timer channel is never applied
>>   - the maximum time that can be represented when using the slow clock may be
>>     wrong if the tc block provide a 32 bits width counter
>>
>> Best Regards,
>>
>> Boris
>>
>> Boris BREZILLON (2):
>>    pwm: atmel-tcb: add missing clk source config
>>    pwm: atmel-tcb: fix max time computation for slow clk source
>>
>>   drivers/pwm/pwm-atmel-tcb.c |    4 +++-
>>   1 file changed, 3 insertions(+), 1 deletion(-)
> Both applied, with Nicolas' Acked-by.
>
> Thierry
Thanks.

Regards,
Boris
