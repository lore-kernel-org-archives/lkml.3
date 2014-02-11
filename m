Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752720AbaBKIan (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 03:30:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12266 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751590AbaBKIal (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 03:30:41 -0500
Message-ID: <52F9DFA4.60106@redhat.com>
Date: Tue, 11 Feb 2014 16:30:28 +0800
From: Jason Wang <jasowang@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>, kys@microsoft.com,
        haiyangz@microsoft.com, tglx@linutronix.de, mingo@redhat.com,
        x86@kernel.org, devel@linuxdriverproject.org,
        linux-kernel@vger.kernel.org
CC: "stable@vger.kernel.org >> Stable" <stable@vger.kernel.org>
Subject: Re: [PATCH] x86, hyperv: bypass the timer_irq_works() check
References: <1390543371-10748-1-git-send-email-jasowang@redhat.com> <52E2D904.6020608@zytor.com> <52E49236.6080805@redhat.com>
In-Reply-To: <52E49236.6080805@redhat.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/26/2014 12:42 PM, Jason Wang wrote:
> On 01/25/2014 05:20 AM, H. Peter Anvin wrote:
>> On 01/23/2014 10:02 PM, Jason Wang wrote:
>>> This patch bypass the timer_irq_works() check for hyperv guest since:
>>>
>>> - It was guaranteed to work.
>>> - timer_irq_works() may fail sometime due to the lpj calibration were inaccurate
>>>   in a hyperv guest or a buggy host.
>>>
>>> In the future, we should get the tsc frequency from hypervisor and use preset
>>> lpj instead.
>>>
>>> Cc: K. Y. Srinivasan <kys@microsoft.com>
>>> Cc: Haiyang Zhang <haiyangz@microsoft.com>
>>> Signed-off-by: Jason Wang <jasowang@redhat.com>
>> This should be in -stable, right?
>>
>> 	-hpa
>>
>>
> Oh, right.
>
> Cc: <stable@vger.kernel.org>

Ping, need I resend the patch or it's ok for you to apply?
