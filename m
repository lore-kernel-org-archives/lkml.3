Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936693Ab3DHP4E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Apr 2013 11:56:04 -0400
Received: from slimlogic.co.uk ([89.16.172.20]:57754 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S936543Ab3DHP4C (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Apr 2013 11:56:02 -0400
Message-ID: <5162E88E.9010204@slimlogic.co.uk>
Date: Mon, 08 Apr 2013 16:55:58 +0100
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Samuel Ortiz <sameo@linux.intel.com>
CC: Ian Lartey <ian@slimlogic.co.uk>, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-leds@vger.kernel.org, linux-watchdog@vger.kernel.org,
        devicetree-discuss@lists.ozlabs.org, swarren@wwwdotorg.org,
        grant.likely@secretlab.ca, broonie@opensource.wolfsonmicro.com,
        rob.herring@calxeda.com, rob@landley.net, mturquette@linaro.org,
        linus.walleij@linaro.org, cooloney@gmail.com, sfr@canb.auug.org.au,
        rpurdie@rpsys.net, akpm@linux-foundation.org, wim@iguana.be,
        lgirdwood@gmail.com, j-keerthy@ti.com, ldewangan@nvidia.com,
        t-kristo@ti.com
Subject: Re: [PATCH v10 0/12] Palmas updates
References: <1363964122-19201-1-git-send-email-ian@slimlogic.co.uk> <20130405163056.GN17363@zurbaran>
In-Reply-To: <20130405163056.GN17363@zurbaran>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/04/13 17:30, Samuel Ortiz wrote:
> Hi Ian,
>
> On Fri, Mar 22, 2013 at 02:55:10PM +0000, Ian Lartey wrote:
>> This patchset adds to the support for the Palmas series of PMIC chips.
>>
>> Some of the patches have previously been submitted individually.
>> The DT bindings doc has been added first due to comments that it was missing.
>>
>> Patches based on linux-next-20130319
> Are you expecting all those patches to go through the MFD tree ?
> Also, you stil have a few comments from Milo and Stephen to adress. Are you
> planning to send a v11 ?
>
>
Hi Samuel,

The device is an MFD so I suspect the best path is through MFD tree
although I notice you have applied the patch that was required by all
other patches so maybe this is not so much the case now!

Real life has got in the way of the next updated series of patches but
they will be issued just as soon as we can.

Thanks

Graeme

