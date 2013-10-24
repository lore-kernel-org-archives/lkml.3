Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755862Ab3JXQjy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 12:39:54 -0400
Received: from merlin.infradead.org ([205.233.59.134]:46314 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755221Ab3JXQjx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 12:39:53 -0400
Message-ID: <52694D54.8040404@infradead.org>
Date: Thu, 24 Oct 2013 09:39:48 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>, Aldo Iljazi <me@aldo.io>
CC: linux-kernel@vger.kernel.org
Subject: Re: Proposal for menuconfig removal
References: <688fb505375d3c5fa1f8d00c81a9dab2@aldo.io> <52692896.70901@ahsoftware.de> <e0a7d6b725f97abf03b4bcf1a4238658@aldo.io> <52693E48.6000905@ahsoftware.de>
In-Reply-To: <52693E48.6000905@ahsoftware.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/24/13 08:35, Alexander Holler wrote:
> Am 24.10.2013 17:02, schrieb Aldo Iljazi:
>> On 24-10-2013 17:03, Alexander Holler wrote:
>>> Am 24.10.2013 13:56, schrieb Aldo Iljazi:
>>>> Since nconfig is there, menuconfig is redundant.
>>>>
>>>> I am proposing to remove it from the kernel.

I am not seeing a good reason to remove menuconfig.

>>>
>>> Looks like nconfig depends on F-keys, which unfortunately do disappear
>>> more and more on modern keyboards, so I wouldn't call that a very good
>>> idea.
>>>
>>> Regards,
>>>
>>> Alexander Holler
>>> -- 
>>
>> If that's the case then I agree, but are they really? I've not seen a
>> keyboard without F-keys.
> 
> There are many of them. But it isn't only about keyboards without those keys, it's about situations where those keys are inaccesible too. Guess why Midnight Commander supports ESC-n as alternative for Fn.
> 
> Or just try to use make nconfig from any of the various Android (SSH)-Terminals. Relying on F-keys isn't a very good idea.

nconfig supports use of <Fn> or just numeric <n> key for the same functions.


-- 
~Randy
