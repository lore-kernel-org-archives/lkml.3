Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3ENQZV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 12:25:21 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:17312 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751194Ab3ENQZU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 12:25:20 -0400
User-Agent: K-9 Mail for Android
In-Reply-To: <51926396.4040203@linaro.org>
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-4-git-send-email-david.vrabel@citrix.com> <51918ABB.5030501@linaro.org> <51920A9502000078000D5D84@nat28.tlf.novell.com> <51925F70.5000309@linaro.org> <51927F2002000078000D6224@nat28.tlf.novell.com> <51926396.4040203@linaro.org>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain;
 charset=UTF-8
Subject: Re: [Xen-devel] [PATCH 3/3] x86/xen: sync the CMOS RTC as well as the Xen wallclock
From: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Date: Tue, 14 May 2013 12:24:57 -0400
To: John Stultz <john.stultz@linaro.org>, Jan Beulich <JBeulich@suse.com>
CC: David Vrabel <david.vrabel@citrix.com>,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>,
        Thomas Gleixner <tglx@linutronix.de>, xen-devel@lists.xen.org,
        linux-kernel@vger.kernel.org
Message-ID: <32efe991-ac51-410b-aead-68a480e628d6@email.android.com>
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

John Stultz <john.stultz@linaro.org> wrote:

>On 05/14/2013 09:14 AM, Jan Beulich wrote:
>>>>> On 14.05.13 at 17:59, John Stultz <john.stultz@linaro.org> wrote:
>>> On 05/14/2013 12:57 AM, Jan Beulich wrote:
>>>>>>> On 14.05.13 at 02:52, John Stultz <john.stultz@linaro.org>
>wrote:
>>>>> Honestly, it seems a little strange to me. If you're running as
>dom0,
>>>>> why does HYPERVISOR_dom0_op() not cause the hypervisor to set the
>cmos
>>>>> its virtualizing? This seems to mess with the proper
>virtualization
>>>>> layering.
>>>> Thy hypervisor tries to control as little system and peripheral
>devices
>>>> as possible, and the CMOS (including the clock) is among those not
>>>> controlled by it, but by Dom0.
>>> Huh. So what does calling HYPERVISOR_dom0_op do then?
>> Here it merely tells the hypervisor that the wall clock changed (so
>> it can propagate this on to DomU-s).
>
>Ok, I appreciate the explanation. Still waiting for acks on this one.
>
>thanks
>-john

Acked-by: Konrad Rzeszutek Wilk

Or Reviewed-by. Or John if you would like I can carry this in my branch for Linus.

Thought it might make sense to add the comment from Jan about the CMOS and the follow up explanation.
-- 
Sent from my Android phone. Please excuse my brevity.
