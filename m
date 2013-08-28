Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753464Ab3H1OCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Aug 2013 10:02:42 -0400
Received: from 17.mo3.mail-out.ovh.net ([87.98.178.58]:50463 "EHLO
	mo3.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1752504Ab3H1OCk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Aug 2013 10:02:40 -0400
Message-ID: <521E02C0.9010003@overkiz.com>
Date: Wed, 28 Aug 2013 16:01:36 +0200
From: boris brezillon <b.brezillon@overkiz.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Ian Campbell <ian.campbell@citrix.com>, Rob Landley <rob@landley.net>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>,
        Richard Genoud <richard.genoud@gmail.com>,
        Jiri Kosina <jkosina@suse.cz>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
X-Ovh-Mailout: 178.32.228.3 (mo3.mail-out.ovh.net)
Subject: Re: [PATCH] pinctrl: at91: add support for OUTPUT config
References: <1377615082-16808-1-git-send-email-b.brezillon@overkiz.com> <CACRpkdbkp-aqYWO=jkBvCT0U3wbKJMBfk2N17cUZeM5rfZiU5Q@mail.gmail.com> <CACRpkdZ+TRb9OFTMHFCW6FYP10hNJFbuods04XK8=zq4bC8cHg@mail.gmail.com>
In-Reply-To: <CACRpkdZ+TRb9OFTMHFCW6FYP10hNJFbuods04XK8=zq4bC8cHg@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-Ovh-Tracer-Id: 198439859903101149
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeikedrheekucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 28/08/2013 15:48, Linus Walleij wrote:
> On Wed, Aug 28, 2013 at 3:46 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>> On Tue, Aug 27, 2013 at 4:51 PM, Boris BREZILLON
>> <b.brezillon@overkiz.com> wrote:
>>
>>> Add support for pin output control through the pinctrl config:
>>>   - support enabling/disabling output on a given pin
>>>   - support output level setting (high or low)
>>>
>>> Signed-off-by: Boris BREZILLON <b.brezillon@overkiz.com>
>> NAK.
>>
>> We already have this:
>>
>>   * @PIN_CONFIG_OUTPUT: this will configure the pin in output, use argument
>>   *      1 to indicate high level, argument 0 to indicate low level.
>>
>> It also has device tree bindings:
>>
>> output-low              - set the pin to output mode with low level
>> output-high             - set the pin to output mode with high level
> Bah maybe I'm misunderstanding :-(
>
> So this is not part of the generic pin config series, but something
> stand-alone to augment the existing driver to do this?

This is a proposal to add support for OUTPUT config using native at91 
pinconf binding (not generic pinconf binding).

I did this to get support for OUTPUT config quickly.

The generic pinconf binding is still in discussion, and will be added as 
soon as at91 maintainers and pinctrl
maintainers agree on how this should be done.

>
> So I just apply this patch right off then?

I don't know, I think we should wait for Jean-Christophe approval.

>
> Yours,
> Linus Walleij

