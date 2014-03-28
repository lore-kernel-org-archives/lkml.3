Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751498AbaC1IIO (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 04:08:14 -0400
Received: from dehamd003.servertools24.de ([31.47.254.18]:47921 "EHLO
	dehamd003.servertools24.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751088AbaC1III (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 04:08:08 -0400
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
X-No-Relay: not in my network
Message-ID: <53352DE5.2090600@ladisch.de>
Date: Fri, 28 Mar 2014 09:08:05 +0100
From: Clemens Ladisch <clemens@ladisch.de>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Feng Tang <feng.tang@intel.com>, Ingo Molnar <mingo@kernel.org>
CC: tglx@linutronix.de, mingo@elte.hu, hpa@zytor.com,
        linux-kernel@vger.kernel.org, John Stultz <john.stultz@linaro.org>,
        Andy Lutomirski <luto@amacapital.net>
Subject: Re: [PATCH v2] x86: hpet: Don't default CONFIG_HPET_TIMER to be y
 for X86_64
References: <1395975316-4795-1-git-send-email-feng.tang@intel.com> <20140328071716.GC30107@gmail.com> <20140328073718.GA12762@feng-snb>
In-Reply-To: <20140328073718.GA12762@feng-snb>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Feng Tang wrote:
> On Fri, Mar 28, 2014 at 08:17:16AM +0100, Ingo Molnar wrote:
>> * Feng Tang <feng.tang@intel.com> wrote:
>>  - or the kernel should have a quirk to reliably disable it. Why
>>    should we crash or misbehave if a driver is built into the
>>    kernel?
>
> I thought about this before, HPET doesn't have PCI ID like stuff,

HPET does have the PCI vendor ID in the first register.

> only thing I can think of to identify them may be the CPU family/ID.

The HPET is implemented by some actual chip, and that chip also has lots
of PCI devices.  (In the case of a SoC, the CPU ID would work, too).


Regards,
Clemens
