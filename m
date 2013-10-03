Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752764Ab3JCIbg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 04:31:36 -0400
Received: from 11.mo4.mail-out.ovh.net ([46.105.34.195]:59970 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751193Ab3JCIbd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 04:31:33 -0400
X-Greylist: delayed 447 seconds by postgrey-1.27 at vger.kernel.org; Thu, 03 Oct 2013 04:31:33 EDT
Message-ID: <524D296B.2090905@overkiz.com>
Date: Thu, 03 Oct 2013 10:23:07 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Fabio Porcedda <fabio.porcedda@gmail.com>
CC: Wim Van Sebroeck <wim@iguana.be>, Nicolas Ferre <nicolas.ferre@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Yang Wenyou <Wenyou.Yang@atmel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        linux-watchdog@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        devicetree-discuss@lists.ozlabs.org, linux-doc@vger.kernel.org
X-Ovh-Mailout: 178.32.228.4 (mo4.mail-out.ovh.net)
Subject: Re: [PATCH v2 2/4] watchdog: at91sam9_wdt: update device tree doc
References: <1371799176-3408-1-git-send-email-b.brezillon@overkiz.com> <1371799414-3654-1-git-send-email-b.brezillon@overkiz.com> <CAHkwnC_Q5XVcb5m5gZuG+s7ojgBb6b29pW9_rENA1sBjo4+-7Q@mail.gmail.com>
In-Reply-To: <CAHkwnC_Q5XVcb5m5gZuG+s7ojgBb6b29pW9_rENA1sBjo4+-7Q@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 2988419829413345417
X-Ovh-Remote: 78.236.240.82 (cha74-5-78-236-240-82.fbx.proxad.net)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiledrudehucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Fabio,

On 03/10/2013 10:08, Fabio Porcedda wrote:
> On Fri, Jun 21, 2013 at 9:23 AM, Boris BREZILLON
> <b.brezillon@overkiz.com> wrote:
>> Add new at91sam9 watchdog properties to the documentation.
>>
>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> ---
>>   .../devicetree/bindings/watchdog/atmel-wdt.txt     |   30 ++++++++++++++++++--
>>   1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>> index fcdd48f..e043106 100644
>> --- a/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>> +++ b/Documentation/devicetree/bindings/watchdog/atmel-wdt.txt
>> @@ -9,11 +9,37 @@ Required properties:
>>
>>   Optional properties:
>>   - timeout-sec: contains the watchdog timeout in seconds.
> Why are you removing the documentation about this property?

I'm not removing the property: this is an enumeration minus not a diff 
minus.

> Regards
Regards,

Boris
