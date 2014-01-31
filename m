Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754135AbaAaNut (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 08:50:49 -0500
Received: from vsp-authed02.binero.net ([195.74.38.226]:58323 "EHLO
	vsp-authed-02-02.binero.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753314AbaAaNuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 08:50:46 -0500
Message-ID: <52EBAA28.1070307@gaisler.com>
Date: Fri, 31 Jan 2014 14:50:32 +0100
From: Andreas Larsson <andreas@gaisler.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Marc Kleine-Budde <mkl@pengutronix.de>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        Wolfgang Grandegger <wg@grandegger.com>
CC: linux-can@vger.kernel.org, netdev@vger.kernel.org,
        sparclinux@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/5] can: sja1000: cleanups and new OF property
References: <1391175277-19833-1-git-send-email-florian.vaussard@epfl.ch> <52EBA7E2.6090007@pengutronix.de>
In-Reply-To: <52EBA7E2.6090007@pengutronix.de>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-01-31 14:40, Marc Kleine-Budde wrote:
> On 01/31/2014 02:34 PM, Florian Vaussard wrote:
>> Hello,
>>
>> (could someone with a SJA1000 on SPARC perform a functional test
>> to see if interrupts are working? it would be great :-)
>>
>> Changes since v2:
>> - Dropped patch 1 "can: sja1000: remove unused defines"
>> - Addressed Marc's comments on patch 4 and 6 (now 3 and 5)
>>
>> Changes since v1:
>> - Merge sja1000_of_platform.c into sja1000_platform.c (patch 4)
>>
>> The first part of this series performs serveral small cleanups
>> (patches 1 and 2).
>>
>> Patch 3 merges sja1000_of_platform.c into sja1000_platform.c.
>> Changes are pretty conservatives (mostly copy/paste/move). IRQ
>> is treated differently in the OF and non-OF versions, thus this
>> is where the fused version differs the most.
>>
>> The final part introduces the 'reg-io-width' binding (already used
>> by some other drivers) to perform a similar job as what was done
>> with IORESOURCE_MEM_XXBIT. This is needed on my system to correctly
>> take into account the aliasing of the address bus.
>>
>> All patches were tested using OF boot on my OMAP3 system with a
>> memory-mapped SJA1000. Thus, the non-OF path is not tested, as
>> I do not have a platform data at hand.
>
> Nice, looks good now. I'll give Andreas some time to test on sparc and
> then apply the patches.


I am on it. I will dig up some hardware for this on Monday to test it.

Best regards,
Andreas

