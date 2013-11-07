Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751773Ab3KGF2J (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 00:28:09 -0500
Received: from e28smtp05.in.ibm.com ([122.248.162.5]:34542 "EHLO
	e28smtp05.in.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750859Ab3KGF2F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 00:28:05 -0500
Message-ID: <527B24D4.30009@linux.vnet.ibm.com>
Date: Thu, 07 Nov 2013 10:57:48 +0530
From: Deepthi Dharwar <deepthi@linux.vnet.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
CC: Daniel Lezcano <daniel.lezcano@linaro.org>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, michael@ellerman.id.au,
        scottwood@freescale.com, srivatsa.bhat@linux.vnet.ibm.com,
        preeti@linux.vnet.ibm.com, linux-pm@lists.linux-foundation.org,
        svaidy@linux.vnet.ibm.com
Subject: Re: [PATCH V7 5/7] POWER/cpuidle: Generic POWER CPUIDLE driver supporting
 PSERIES.
References: <20131029110052.31547.82682.stgit@deepthi.in.ibm.com> <20131029110148.31547.8944.stgit@deepthi.in.ibm.com> <527AAF1D.5080605@linaro.org> <527B13C8.9030602@linux.vnet.ibm.com> <1383800462.4776.165.camel@pasglop>
In-Reply-To: <1383800462.4776.165.camel@pasglop>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13110705-8256-0000-0000-00000A045048
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/07/2013 10:31 AM, Benjamin Herrenschmidt wrote:
> On Thu, 2013-11-07 at 09:45 +0530, Deepthi Dharwar wrote:
>> 'powerpc' would be very generic arch and would comprise of all platforms
>> including embedded 32/64 bit to server 64 bit (similar to that of ARM).
>> This driver does not intend to support complete powerpc arch, but just
>> PSERIES and POWERNV platforms termed as 'POWER' processors. So to avoid
>> confusion btw 'power mgmt' and 'POWER' archs, I have prefixed both the
>> driver and file names with 'IBM'namely ibm-power-driver, cpuidle-ibm-power.
> 

Hi Ben,

> Why not book3s ? powerpc-book3s ?

I went with 'ibm-power' thinking it would resolve the confusion,
but if ppl feel that is is good to get away from 'POWER' and have
powerpc-book3s instead to make things clearer, I am open for it.


Regards,
Deepthi

> That's what we use in other places to differenciate between the families
> 
> Ben.
> 
> 

