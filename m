Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755548Ab3JXPfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Oct 2013 11:35:48 -0400
Received: from h1446028.stratoserver.net ([85.214.92.142]:38475 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754131Ab3JXPfr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Oct 2013 11:35:47 -0400
Message-ID: <52693E48.6000905@ahsoftware.de>
Date: Thu, 24 Oct 2013 17:35:36 +0200
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130805 Thunderbird/17.0.8
MIME-Version: 1.0
To: Aldo Iljazi <me@aldo.io>
CC: linux-kernel@vger.kernel.org
Subject: Re: Proposal for menuconfig removal
References: <688fb505375d3c5fa1f8d00c81a9dab2@aldo.io> <52692896.70901@ahsoftware.de> <e0a7d6b725f97abf03b4bcf1a4238658@aldo.io>
In-Reply-To: <e0a7d6b725f97abf03b4bcf1a4238658@aldo.io>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 24.10.2013 17:02, schrieb Aldo Iljazi:
> On 24-10-2013 17:03, Alexander Holler wrote:
>> Am 24.10.2013 13:56, schrieb Aldo Iljazi:
>>> Since nconfig is there, menuconfig is redundant.
>>>
>>> I am proposing to remove it from the kernel.
>>>
>>
>> Looks like nconfig depends on F-keys, which unfortunately do disappear
>> more and more on modern keyboards, so I wouldn't call that a very good
>> idea.
>>
>> Regards,
>>
>> Alexander Holler
>> --
>
> If that's the case then I agree, but are they really? I've not seen a
> keyboard without F-keys.

There are many of them. But it isn't only about keyboards without those 
keys, it's about situations where those keys are inaccesible too. Guess 
why Midnight Commander supports ESC-n as alternative for Fn.

Or just try to use make nconfig from any of the various Android 
(SSH)-Terminals. Relying on F-keys isn't a very good idea.

Regards,

Alexander Holler
