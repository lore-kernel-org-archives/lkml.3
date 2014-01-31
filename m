Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932427AbaAaMlm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 07:41:42 -0500
Received: from smtp4.epfl.ch ([128.178.224.219]:55592 "EHLO smtp4.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932145AbaAaMlk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 07:41:40 -0500
Message-ID: <52EB9A00.9050102@epfl.ch>
Date: Fri, 31 Jan 2014 13:41:36 +0100
From: Florian Vaussard <florian.vaussard@epfl.ch>
Reply-To: florian.vaussard@epfl.ch
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/6] can: sja1000: cleanups and new OF property
References: <1391164513-11529-1-git-send-email-florian.vaussard@epfl.ch> <52EB9908.2090903@pengutronix.de>
In-Reply-To: <52EB9908.2090903@pengutronix.de>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Marc,

On 01/31/2014 01:37 PM, Marc Kleine-Budde wrote:
> On 01/31/2014 11:35 AM, Florian Vaussard wrote:
>> Hello,
>>
>> Changes sinces v1:
>> - Merge sja1000_of_platform.c into sja1000_platform.c (patch 4)
>>
>> The first part of this series performs serveral small cleanups
>> (patches 1 to 3).
>>
>> Patch 4 merges sja1000_of_platform.c into sja1000_platform.c.
>> Changes are pretty conservatives (mostly copy/paste/move). IRQ
>> is treated differently in the OF and non-OF versions, thus this
>> is where the fused version differs the most.
>>
>> The final part introduces the 'reg-io-width' binding (already used
>> by some other drivers) to perform a similar job as what was done
>> with IORESOURCE_MEM_XXBIT. This is needed on my system to correctly
>> take into account the aliasing of the address bus.
> 
> Good work, please keep compatibility for DTs without the 'reg-io-width'
> binding. The rest of my comments are only nitpicks. :)
> 

Good points. I will send a v3.

Regards,

Florian
