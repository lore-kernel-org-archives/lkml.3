Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754696Ab3ARWdL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 17:33:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:48232 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751092Ab3ARWdK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 17:33:10 -0500
Message-ID: <50F9CD9E.1050902@oracle.com>
Date: Fri, 18 Jan 2013 16:33:02 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com> <x49obgmif7w.fsf@segfault.boston.devel.redhat.com> <x49k3raidd6.fsf@segfault.boston.devel.redhat.com> <50F98D29.6050701@oracle.com> <x4938xyi2mm.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x4938xyi2mm.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 03:48 PM, Jeff Moyer wrote:
> Dave Kleikamp <dave.kleikamp@oracle.com> writes:
> 
>> On 01/18/2013 11:56 AM, Jeff Moyer wrote:
>>> Jeff Moyer <jmoyer@redhat.com> writes:
>>>
>>>> ./check -g aio
>>>>
>>>> and here is the summary:
>>>>
>>>> Ran: 112 113 198 207 208 209 210 211 212 239 240
>>>> Failures: 112 198 207 239 240
>>>> Failed 5 of 11 tests
>>>>
>>>> To be fair, I have not yet run this on a kernel without your changes.
>>>
>>> I re-ran the same test against a vanilla 3.8.0-rc4 kernel and it passed:
>>>
>>> Ran: 112 113 198 207 208 209 210 211 212 239 240
>>> Passed all 11 tests
>>>
>>> I'll start digging into the failures.
>>
>> Thanks, I'll take a look at it too.
> 
> Note that the failures occur on regular block devices, too;  this isn't
> restricted to loop.  The fix I mentioned in reply to patch 17 actually
> fixes all of the failures reported in the aio group.  I'm going to do
> some more thorough testing over the weekend.

Thanks much. I'll definitely add this to my testing.

Shaggy

> 
> Cheers,
> Jeff
> 
