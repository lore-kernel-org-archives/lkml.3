Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753300Ab3AYWPk (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 17:15:40 -0500
Received: from terminus.zytor.com ([198.137.202.10]:47264 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753047Ab3AYWPi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 17:15:38 -0500
Message-ID: <510303F8.1080105@zytor.com>
Date: Fri, 25 Jan 2013 14:15:20 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: "H. Peter Anvin" <hpa@zytor.com>
CC: mingo@kernel.org, linux-kernel@vger.kernel.org, konrad.wilk@oracle.com,
        torvalds@linux-foundation.org, JBeulich@suse.com, tglx@linutronix.de,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/asm] x86/xor: Make virtualization friendly
References: <5093E4F302000078000A6162@nat28.tlf.novell.com> <tip-05fbf4d6fc6a3c0c3e63b77979c9311596716d10@git.kernel.org> <510302FD.3090009@zytor.com>
In-Reply-To: <510302FD.3090009@zytor.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2013 02:11 PM, H. Peter Anvin wrote:
> On 01/25/2013 02:43 AM, tip-bot for Jan Beulich wrote:
>> Commit-ID:  05fbf4d6fc6a3c0c3e63b77979c9311596716d10
>> Gitweb:     http://git.kernel.org/tip/05fbf4d6fc6a3c0c3e63b77979c9311596716d10
>> Author:     Jan Beulich <JBeulich@suse.com>
>> AuthorDate: Fri, 2 Nov 2012 14:21:23 +0000
>> Committer:  Ingo Molnar <mingo@kernel.org>
>> CommitDate: Fri, 25 Jan 2013 09:23:51 +0100
>>
>> x86/xor: Make virtualization friendly
>>
>> In virtualized environments, the CR0.TS management needed here
>> can be a lot slower than anticipated by the original authors of
>> this code, which particularly means that in such cases forcing
>> the use of SSE- (or MMX-) based implementations is not desirable
>> - actual measurements should always be done in that case.
>>
>> For consistency, pull into the shared (32- and 64-bit) header
>> not only the inclusion of the generic code, but also that of the
>> AVX variants.
>>
> 
> This patch is wrong and should be dropped.  I verified it with the KVM
> people that they do NOT want this change.  It is a Xen-specific problem.
> 

FWIW: I have dropped this patch from tip:x86/asm.

	-hpa


