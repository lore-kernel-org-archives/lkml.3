Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752225Ab3CBMNt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 2 Mar 2013 07:13:49 -0500
Received: from slimlogic.co.uk ([89.16.172.20]:53008 "EHLO slimlogic.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751975Ab3CBMNs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 2 Mar 2013 07:13:48 -0500
Message-ID: <5131ECEF.2080101@slimlogic.co.uk>
Date: Sat, 02 Mar 2013 20:13:35 +0800
From: Graeme Gregory <gg@slimlogic.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130221 Thunderbird/17.0.3
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: Stephen Warren <swarren@wwwdotorg.org>,
        Laxman Dewangan <ldewangan@nvidia.com>,
        "sameo@linux.intel.com" <sameo@linux.intel.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephen Warren <swarren@nvidia.com>,
        "ian@slimlogic.co.uk" <ian@slimlogic.co.uk>
Subject: Re: [PATCH] mfd: palmas: provide irq flags through DT/platform data
References: <1362141296-15321-1-git-send-email-ldewangan@nvidia.com> <20130301124350.GA25302@opensource.wolfsonmicro.com> <5130A53C.1000600@nvidia.com> <20130301131633.GB25302@opensource.wolfsonmicro.com> <513102D0.5030609@wwwdotorg.org> <20130302033525.GD6610@opensource.wolfsonmicro.com>
In-Reply-To: <20130302033525.GD6610@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/03/13 11:35, Mark Brown wrote:
> On Fri, Mar 01, 2013 at 12:34:40PM -0700, Stephen Warren wrote:
>
>> Is Palmas a family of chips rather than a single chip then? That
>> implies that the DT would need two compatible values, e.g.:
> Yes.
>
>> compatible = "ti,12345", "ti,palmas";
>> ... where "12345" is the actual chip name.
>> ... rather than just the following which IIRC was in the example in
>> the DT binding document in another patch series:
>> compatible = "ti,palmas";
> Indeed, and in fact this has already been done for the I2C device ID
> table.  We should have the same list of devices in the OF IDs.
Currently all members of the palmas family I know about (from memory).

For palmas :-
twl6035, twl6037, tps65913, tps65914

For palmas-charger :-
twl6036, tps80036

All with varying IP blocks or hardware configuration.

Mainly this is due to misunderstanding I had of DT definitions when I
originally read docs, when driver project commenced. I will work with
Ian, Laxman, Keerthy and get these updated.

Should these also flow down into the various drivers for the IP blocks? eg.

compatible = "ti,twl6035-regulator", "ti,palmas-regulator";

Graeme

