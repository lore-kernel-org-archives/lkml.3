Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754046Ab3AXMAN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 07:00:13 -0500
Received: from multi.imgtec.com ([194.200.65.239]:56937 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753830Ab3AXMAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 07:00:10 -0500
Message-ID: <51012244.9070002@imgtec.com>
Date: Thu, 24 Jan 2013 12:00:04 +0000
From: James Hogan <james.hogan@imgtec.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Vineet Gupta <Vineet.Gupta1@synopsys.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2 00/76] Synopsys ARC Linux kernel Port
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <201301181512.14441.arnd@arndb.de> <5100F6AD.5050001@synopsys.com> <51010461.20604@imgtec.com> <510108B9.3020205@synopsys.com>
In-Reply-To: <510108B9.3020205@synopsys.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [192.168.154.65]
X-SEF-Processed: 7_3_0_01181__2013_01_24_12_00_05
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 24/01/13 10:11, Vineet Gupta wrote:
> On Thursday 24 January 2013 03:22 PM, James Hogan wrote:
>> Hi Vineet,
>>
>> On 24/01/13 08:54, Vineet Gupta wrote:
>>> (3) That branch will be ARC patches on top of Linus's 3.8 rc4. Actually for my
>>> development, I'd also cherry picked a few patches from linux-next (soft and hard
>>> dependencies from several different *next trees) - hard ones being
>>>
>>> f13a366 CONFIG_GENERIC_SIGALTSTACK build breakage with asm-generic/syscalls.h [Al]
>> FYI this one has now been merged into Linus' master.
>>
>> Cheers
>> James
>>
> 
> OK thanks - but I'd rather have the patches based on a well known checkpoint - so
> maybe wait for next rc.

In that case you may like to merge Al's for-linus branch in the mean
time, or the commit you want directly, since it's definitely gone into
the master without being rebased.

> Any ideas about other questions on the thread - given that several next trees are
> still involved.

Stephen said it's fine to merge other trees as long as you let them know
so they don't rebase, or ask them which branch is best to use that won't
rebase. See the following thread:
https://lkml.org/lkml/2013/1/11/187

> metag doesn't seem to be on linux-next yet ?

Not yet, although I think it's almost ready. I need to solicit some acks.

Cheers
James

