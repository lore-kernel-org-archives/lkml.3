Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759291AbaDJWwC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 18:52:02 -0400
Received: from mail.active-venture.com ([67.228.131.205]:51708 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754021AbaDJWv6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 18:51:58 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5347208A.6000202@roeck-us.net>
Date: Thu, 10 Apr 2014 15:51:54 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: David Cohen <david.a.cohen@linux.intel.com>
CC: wim@iguana.be, tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-watchdog@vger.kernel.org, gnomes@lxorguk.ukuu.org.uk
Subject: Re: [PATCH 2/2] x86: intel-mid: add watchdog platform code for Merrifield
References: <1396990744-10695-1-git-send-email-david.a.cohen@linux.intel.com> <1396990744-10695-3-git-send-email-david.a.cohen@linux.intel.com> <20140410191523.GA6206@roeck-us.net> <20140410193010.GD28420@psi-dev26.jf.intel.com> <20140410203536.GB25534@roeck-us.net> <20140410212352.GE28420@psi-dev26.jf.intel.com>
In-Reply-To: <20140410212352.GE28420@psi-dev26.jf.intel.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/10/2014 02:23 PM, David Cohen wrote:
> On Thu, Apr 10, 2014 at 01:35:36PM -0700, Guenter Roeck wrote:
>> On Thu, Apr 10, 2014 at 12:30:10PM -0700, David Cohen wrote:
>>> On Thu, Apr 10, 2014 at 12:15:23PM -0700, Guenter Roeck wrote:
>>>> On Tue, Apr 08, 2014 at 01:59:04PM -0700, David Cohen wrote:
>>>>> This patch adds platform code for Intel Merrifield.
>>>>> Since the watchdog is not part of SFI table, we have no other option but
>>>>> to manually register watchdog's platform device (argh!).
>>>>>
>>>>> Signed-off-by: David Cohen <david.a.cohen@linux.intel.com>
>>>>> ---
>>>>
>>>> Does it really make sense to have this as separate patch ?
>>>>
>>>> It is quite common for watchdog (and many other) drivers to
>>>> register the driver and instantiate the device. I think it
>>>> would be better and more consistent to have both patches
>>>> merged into one.
>>>
>>> Are you talking about to merge them without code changes or make the
>>> driver responsible for the device enumeration (by make the driver to
>>> allocate the device)?
>>>
>>> If it's a simple merge, I'd say I don't like to mix drivers and arch
>>> patches.
>>>
>>> If we're talking about moving the device registration to driver, I
>>> strongly disagree it would be better and more consistent. The way I sent
>>> the driver makes it less dependent of how the enumeration happens.
>>> If this device is added to SFI table, the driver would need no change.
>>>
>> I don't see why that would be a problem. Guess we'll have to agree
>> to disagree.
>
> Sounds fine :)
> If you're not too much against keeping the way it is, I'd like to send
> the v2 with 2 patches again.
>

Not my decision to make. I am not the watchdog maintainer.

Guenter


