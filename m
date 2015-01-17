Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751453AbbAQImO (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Jan 2015 03:42:14 -0500
Received: from mail-wg0-f50.google.com ([74.125.82.50]:50979 "EHLO
	mail-wg0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750826AbbAQImN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Jan 2015 03:42:13 -0500
Message-ID: <54BA2063.1020702@gmail.com>
Date: Sat, 17 Jan 2015 09:42:11 +0100
From: "Michael Kerrisk (man-pages)" <mtk.manpages@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.2.0
MIME-Version: 1.0
To: Darren Hart <dvhart@infradead.org>
CC: mtk.manpages@gmail.com, Thomas Gleixner <tglx@linutronix.de>,
        lkml <linux-kernel@vger.kernel.org>, Darren Hart <darren@dvhart.com>,
        Ingo Molnar <mingo@elte.hu>
Subject: Re: [PATCH 2/2] futex: Fix argument handling in futex_lock_pi() calls
References: <54B96646.8010200@gmail.com> <20150117020401.GB6494@vmdeb7>
In-Reply-To: <20150117020401.GB6494@vmdeb7>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/17/2015 03:04 AM, Darren Hart wrote:
> On Fri, Jan 16, 2015 at 08:28:06PM +0100, Michael Kerrisk (man-pages) wrote:
>> From: Michael Kerrisk <mtk.manpages@gmail.com>
>>
>> This patch fixes two separate buglets in calls to futex_lock_pi():
>>
>>   * Eliminate unused 'detect' argument
>>   * Change unused 'timeout' argument of FUTEX_TRYLOCK_PI to NULL
> 
> One might argue these should be two separate fixes. Since both are trivial and functional
> no-ops, I'm going to ignore it and consider it a "cleanup" :-) Thomas may
> disagree.

Yup, and that's what I was going to do until I realized that the patches 
changed the same line. Then I thought it easier to combine them (rather 
than make dependent patches), since they're fairly trivial. But,
I'll split them if Thomas wishes.

Thanks,

Michael


-- 
Michael Kerrisk
Linux man-pages maintainer; http://www.kernel.org/doc/man-pages/
Linux/UNIX System Programming Training: http://man7.org/training/
