Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751192AbaI2GBY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 02:01:24 -0400
Received: from mout.kundenserver.de ([212.227.17.10]:58539 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750729AbaI2GBW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 02:01:22 -0400
Message-ID: <5428F592.3020809@i2se.com>
Date: Mon, 29 Sep 2014 08:00:50 +0200
From: Stefan Wahren <stefan.wahren@i2se.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:31.0) Gecko/20100101 Thunderbird/31.1.2
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: lgirdwood@gmail.com, shawn.guo@linaro.org, robh+dt@kernel.org,
        pawel.moll@arm.com, mark.rutland@arm.com,
        ijc+devicetree@hellion.org.uk, galak@codeaurora.org,
        festevam@gmail.com, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kernel@pengutronix.de
Subject: Re: [PATCH 1/2] DT: add binding for mxs regulator
References: <1411779588-22031-1-git-send-email-stefan.wahren@i2se.com> <1411779588-22031-2-git-send-email-stefan.wahren@i2se.com> <20140928102202.GM27755@sirena.org.uk>
In-Reply-To: <20140928102202.GM27755@sirena.org.uk>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-Provags-ID: V02:K0:udFk/AzBbQUqkbX4z1eWXfsShxWgWH6PlSokp7aiFlQ
 8HAhaFir9BOQy4RFWbl0Xs8aHdN6bxNoM6KB3iWmsgowy841Kb
 frYb1eVIFPvpBdILTZepMzGdT4T8Lu8fLfWjdvktENJbPZ9Kb/
 9XT6d+BKZ0zJprmT+UXWE+Nr10nnlau6AVDso2KjrIu3NajmvD
 PbusdEtfr0iHYtr4kAgfS+WOMaLrQ+rj/TF7Onjqck4Y7H4TS0
 YBJ8CiVAk9PP3c0T036oAzmbzn0vjfbFABwSMZPf7YdoMRxQW0
 ud/6WLJROo4PbE+5rIbr6GcZ0vp1hF0hXFIk3f5E64ZNsTOITc
 fKlErm6pO2drrOSGnTVY=
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Mark,

Am 28.09.2014 um 12:22 schrieb Mark Brown:
> On Sat, Sep 27, 2014 at 12:59:47AM +0000, Stefan Wahren wrote:
>> This patch adds the Device tree bindings for the Freescale MXS
>> on-chip regulators.
> Use subject lines matching the style for the subsystem.

sorry i'm not sure what's wrong with the subject lines.

Did you expect "[PATCH 1/2] regulator: add binding for mxs regulator"?

>
>> +Required regulator properties:
>> +- compatible: Must be "fsl,mxs-regulator"
>> +- reg: Absolute physical address of the register set for the regulator
>> +
>> +Any regulator property defined as part of the core regulator
>> +binding, defined in regulator.txt, can also be used.
> While this should be using compatibles to identify which regulator is
> being supported note that the binding doesn't document the fact that the
> code makes regulator-name mandatory or what values are required.

Is the following better?

- fsl,mxs-regulator-vddd
- fsl,mxs-regulator-vdda
- fsl,mxs-regulator-vddio

Thanks

Stefan
