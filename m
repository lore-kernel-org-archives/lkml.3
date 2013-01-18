Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755026Ab3ARR6L (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:58:11 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:44653 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751487Ab3ARR6I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:58:08 -0500
Message-ID: <50F98D29.6050701@oracle.com>
Date: Fri, 18 Jan 2013 11:58:01 -0600
From: Dave Kleikamp <dave.kleikamp@oracle.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130109 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jeff Moyer <jmoyer@redhat.com>
CC: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Zach Brown <zab@zabbo.net>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>
Subject: Re: [PATCH V5 00/30] loop: Issue O_DIRECT aio using bio_vec
References: <1357761525-22718-1-git-send-email-dave.kleikamp@oracle.com> <x49obgmif7w.fsf@segfault.boston.devel.redhat.com> <x49k3raidd6.fsf@segfault.boston.devel.redhat.com>
In-Reply-To: <x49k3raidd6.fsf@segfault.boston.devel.redhat.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 11:56 AM, Jeff Moyer wrote:
> Jeff Moyer <jmoyer@redhat.com> writes:
> 
>> ./check -g aio
>>
>> and here is the summary:
>>
>> Ran: 112 113 198 207 208 209 210 211 212 239 240
>> Failures: 112 198 207 239 240
>> Failed 5 of 11 tests
>>
>> To be fair, I have not yet run this on a kernel without your changes.
> 
> I re-ran the same test against a vanilla 3.8.0-rc4 kernel and it passed:
> 
> Ran: 112 113 198 207 208 209 210 211 212 239 240
> Passed all 11 tests
> 
> I'll start digging into the failures.

Thanks, I'll take a look at it too.

Shaggy

> 
> Cheers,
> Jeff
> 
