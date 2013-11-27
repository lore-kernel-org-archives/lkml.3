Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752755Ab3K0FiO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 00:38:14 -0500
Received: from mail-la0-f54.google.com ([209.85.215.54]:37100 "EHLO
	mail-la0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751216Ab3K0FiJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 00:38:09 -0500
MIME-Version: 1.0
In-Reply-To: <20131126111706.GA2410@gmail.com>
References: <cover.1385418410.git.jbaron@akamai.com>
	<20131126111706.GA2410@gmail.com>
Date: Tue, 26 Nov 2013 23:38:08 -0600
Message-ID: <CAMP44s3=6wmxcoRnnTDvn1KV4mg0_-noy7g8i-ftUnc+Fibj0A@mail.gmail.com>
Subject: Re: [PATCH 0/3 v3] build in panic_timeout value
From: Felipe Contreras <felipe.contreras@gmail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Jason Baron <jbaron@akamai.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Paul Mackerras <paulus@samba.org>, ralf@linux-mips.org,
        Andrew Morton <akpm@linux-foundation.org>, mpe@ellerman.id.au,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 26, 2013 at 5:17 AM, Ingo Molnar <mingo@kernel.org> wrote:
> * Jason Baron <jbaron@akamai.com> wrote:

>> I've now separated out the arch bits into separate patches.
>> Hopefully, it makes review easier. I also didn't address moving the
>> 'panic_timeout' command-line parameter up as an 'early_param()'. I
>> think it might make sense to move it up, especially for distro
>> kernels, but its not a need here, so I didn't want to just shove it
>> in. If needed, I think it can come in separately, as it shoudn't
>> affect this series.
>
> The series looks good to me, I've applied the patches to
> tip:core/debug.
>
> If Felipe Contreras's fix patch looks good to you then it would also
> be nice if you could send me that as well, on top of your patches.

Why? Because for ad hominem reasons you wouldn't take the patch itself
even though it's obviously good?

> That fix patch had only one remaining bug/problem, last I checked: if
> panic_timeout is turned into an early_param() then pause_on_oops
> should obviously also be turned into an early param.

That is not a "problem" with the patch itself, and it's the first time
this "problem" has been mentioned at all.

-- 
Felipe Contreras
