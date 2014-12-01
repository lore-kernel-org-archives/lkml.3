Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752852AbaLAJnr (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 04:43:47 -0500
Received: from eusmtp01.atmel.com ([212.144.249.242]:29125 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752039AbaLAJnp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 04:43:45 -0500
Message-ID: <547C384E.80705@atmel.com>
Date: Mon, 1 Dec 2014 10:43:42 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Boris Brezillon <boris.brezillon@free-electrons.com>,
        Lee Jones <lee.jones@linaro.org>
CC: Samuel Ortiz <sameo@linux.intel.com>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        "Kumar Gala" <galak@codeaurora.org>, <devicetree@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 03/11] mfd: syscon: Add atmel-smc registers definition
References: <1415203287-21517-1-git-send-email-boris.brezillon@free-electrons.com>	<1415203287-21517-4-git-send-email-boris.brezillon@free-electrons.com>	<20141110095728.GJ21424@x1> <20141201103838.4a7a0ffa@bbrezillon>
In-Reply-To: <20141201103838.4a7a0ffa@bbrezillon>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Le 01/12/2014 10:38, Boris Brezillon a écrit :
> Hi Lee,
> 
> Sorry for the late reply.
> 
> On Mon, 10 Nov 2014 09:57:28 +0000
> Lee Jones <lee.jones@linaro.org> wrote:
> 
>> On Wed, 05 Nov 2014, Boris Brezillon wrote:
>>
>>> Atmel AT91 SoCs have a memory range reserved for SMC (Static Memory
>>> Controller) configuration.
>>> Expose those registers so that drivers can make use of the smc syscon
>>> declared in at91 DTs.
>>>
>>> Signed-off-by: Boris Brezillon <boris.brezillon@free-electrons.com>
>>> ---
>>>  include/linux/mfd/syscon/atmel-smc.h | 60 ++++++++++++++++++++++++++++++++++++
>>>  1 file changed, 60 insertions(+)
>>>  create mode 100644 include/linux/mfd/syscon/atmel-smc.h
>>
>> Acked-by: Lee Jones <lee.jones@linaro.org>
>>
>> Any idea who will take this set?
> 
> I guess you could take patch 1 to 4 and Nicolas would take the other
> ones (unless there's a maintainer for memory controller drivers).
> Or, if we don't want to have dependency issues, Nicolas can take all of
> them.
> 
> Nicolas, any preference ?

Yes, I'd prefer to take the whole series. So add your Acked-by tags and
I take all in one of my at91-x.yy-drivers branches.

Bye,
-- 
Nicolas Ferre
