Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932381Ab3E2QMo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 12:12:44 -0400
Received: from multi.imgtec.com ([194.200.65.239]:21245 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751118Ab3E2QMg (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 12:12:36 -0400
Message-ID: <51A628E1.8060805@imgtec.com>
Date: Wed, 29 May 2013 17:12:17 +0100
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Linus Walleij <linus.walleij@linaro.org>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Grant Likely" <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        "devicetree-discuss@lists.ozlabs.org" 
	<devicetree-discuss@lists.ozlabs.org>
Subject: Re: [PATCH v2 9/9] gpio-tz1090-pdc: add TZ1090 PDC gpio driver
References: <1369412476-14245-1-git-send-email-james.hogan@imgtec.com> <1369412476-14245-10-git-send-email-james.hogan@imgtec.com> <CACRpkdZ0Gav0TKDXyD9MwaUrdcenV=+JV9oWNN1+ifsbO3uJ1w@mail.gmail.com>
In-Reply-To: <CACRpkdZ0Gav0TKDXyD9MwaUrdcenV=+JV9oWNN1+ifsbO3uJ1w@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01192__2013_05_29_17_12_18
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29/05/13 16:38, Linus Walleij wrote:
> On Fri, May 24, 2013 at 6:21 PM, James Hogan <james.hogan@imgtec.com> wrote:
>> +Optional properties:
>> +- gpio-ranges: Mapping to pin controller pins
>> +
>> +- interrupts: Individual syswake interrupts (other GPIOs cannot interrupt)
>> +
>> +
>> +Example:
>> +
>> +       pdc_gpios: gpio-controller@02006500 {
>> +               gpio-controller;
>> +               #gpio-cells = <2>;
>> +
>> +               compatible = "img,tz1090-pdc-gpio";
>> +               reg = <0x02006500 0x100>;
>> +
>> +               interrupt-parent = <&pdc>;
>> +               interrupts =    <1 0 0>,        /* Syswake 0 */
>> +                               <1 1 0>,        /* Syswake 1 */
>> +                               <1 2 0>;        /* Syswake 2 */
>> +       };
> 
> Interrupt flags seem to be undocumented here.

Hmmm yes, good spot.

Thanks
James

