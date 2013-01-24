Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753354Ab3AXKNC (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 05:13:02 -0500
Received: from us02smtp1.synopsys.com ([198.182.60.75]:46971 "EHLO
	vaxjo.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752923Ab3AXKMv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 05:12:51 -0500
Message-ID: <510108B9.3020205@synopsys.com>
Date: Thu, 24 Jan 2013 15:41:05 +0530
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: James Hogan <james.hogan@imgtec.com>
CC: Arnd Bergmann <arnd@arndb.de>, <linux-arch@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>,
        Stephen Rothwell <sfr@canb.auug.org.au>
Subject: Re: [PATCH v2 00/76] Synopsys ARC Linux kernel Port
References: <1358511930-7424-1-git-send-email-vgupta@synopsys.com> <201301181512.14441.arnd@arndb.de> <5100F6AD.5050001@synopsys.com> <51010461.20604@imgtec.com>
In-Reply-To: <51010461.20604@imgtec.com>
Content-Type: text/plain; charset="ISO-8859-15"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.12.197.205]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 24 January 2013 03:22 PM, James Hogan wrote:
> Hi Vineet,
>
> On 24/01/13 08:54, Vineet Gupta wrote:
>> (3) That branch will be ARC patches on top of Linus's 3.8 rc4. Actually for my
>> development, I'd also cherry picked a few patches from linux-next (soft and hard
>> dependencies from several different *next trees) - hard ones being
>>
>> f13a366 CONFIG_GENERIC_SIGALTSTACK build breakage with asm-generic/syscalls.h [Al]
> FYI this one has now been merged into Linus' master.
>
> Cheers
> James
>

OK thanks - but I'd rather have the patches based on a well known checkpoint - so
maybe wait for next rc.
Any ideas about other questions on the thread - given that several next trees are
still involved.

metag doesn't seem to be on linux-next yet ?

-Vineet
