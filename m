Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751134AbaBCILp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 03:11:45 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:58976 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750789AbaBCILm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 03:11:42 -0500
Message-ID: <52EF4F39.8010403@epfl.ch>
Date: Mon, 03 Feb 2014 09:11:37 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org, Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, devicetree@vger.kernel.org
Subject: Re: [PATCH v2 5/6] Documentation: devicetree: sja1000: add reg-io-width
 binding
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch> <1391164513-11529-6-git-send-email-florian.vaussard@epfl.ch> <52EB9723.3080008@pengutronix.de>
In-Reply-To: <52EB9723.3080008@pengutronix.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On 01/31/2014 01:29 PM, Marc Kleine-Budde wrote:
> On 01/31/2014 11:35 AM, Florian Vaussard wrote:
>> Add the reg-io-width property to describe the width of the memory
>> accesses.
>>
>> Cc: Grant Likely <grant.likely@linaro.org>
>> Cc: Rob Herring <robh+dt@kernel.org>
>> Cc: Pawel Moll <pawel.moll@arm.com>
>> Cc: Mark Rutland <mark.rutland@arm.com>
>> Cc: Ian Campbell <ijc+devicetree@hellion.org.uk>
>> Cc: Kumar Gala <galak@codeaurora.org>
>> Cc: devicetree@vger.kernel.org
>> Acked-by: Rob Herring <robh@kernel.org>
>> Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
> 
> I think it makes sense to squash into patch 6.
> 

According to recent guidelines from the DT maintainers [1], the
documentation part should be a separate patch. I guess it makes sense to
ease the review process for new bindings.

Regards
Florian

[1]
https://git.kernel.org/cgit/linux/kernel/git/torvalds/linux.git/tree/Documentation/devicetree/bindings/submitting-patches.txt
