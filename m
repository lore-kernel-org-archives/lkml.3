Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758022AbaDWT13 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:27:29 -0400
Received: from mail-ig0-f171.google.com ([209.85.213.171]:60017 "EHLO
	mail-ig0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751182AbaDWT1Z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:27:25 -0400
MIME-Version: 1.0
In-Reply-To: <20140423190015.GF25378@pd.tnic>
References: <20140423170418.GA12767@quad>
	<20140423190015.GF25378@pd.tnic>
Date: Wed, 23 Apr 2014 12:27:24 -0700
Message-ID: <CAHdzE-_jJOKo5=m2DAAhaAbDv4Cbq6KaQg4w_tZdofY_wrOWug@mail.gmail.com>
Subject: Re: [PATCH] perf/x86: fix RAPL rdmsrl_safe() usage
From: Venkatesh Srinivas <venkateshs@google.com>
To: Borislav Petkov <bp@alien8.de>
Cc: Stephane Eranian <eranian@google.com>,
        Linux Kernel Developers List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, mingo@elte.hu,
        Andi Kleen <ak@linux.intel.com>, zheng.z.yan@intel.com
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 12:00 PM, Borislav Petkov <bp@alien8.de> wrote:
> On Wed, Apr 23, 2014 at 07:04:19PM +0200, Stephane Eranian wrote:
>>
>> This patch fixes a bug introduced by commit 24223657.
>
> Maybe add
>
> Fixes: <commit-id>
>
> tag?
>
>> The rdmsrl_safe() function returns 0 on success.
>> The current code was failing to detect the RAPL PMU
>> on real hardware  (missing /sys/devices/power) because
>> the return value of rdmsrl_safe() was misinterpreted.
>>
>> Signed-off-by: Stephane Eranian <eranian@google.com>
>
> Acked-by: Borislav Petkov <bp@suse.de>

Brown-Paper-Bag-Worn-By: Venkatesh Srinivas <venkateshs@google.com>

-- vs;
