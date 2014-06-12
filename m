Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755502AbaFLBiN (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Jun 2014 21:38:13 -0400
Received: from ns.horizon.com ([71.41.210.147]:15945 "HELO ns.horizon.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with SMTP
	id S1754411AbaFLBiJ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Jun 2014 21:38:09 -0400
Date: 11 Jun 2014 21:38:08 -0400
Message-ID: <20140612013808.20579.qmail@ns.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: akpm@linux-foundation.org, linux@horizon.com
Subject: Re: [PATCH v2 2/3] lib: glob.c: Add CONFIG_GLOB_SELFTEST
Cc: linux-ide@vger.kernel.org, linux-kernel@vger.kernel.org, mingo@redhat.com,
        rdunlap@infradead.org, tj@kernel.org
In-Reply-To: <20140611160452.7715d3c4a0cb584e8b507da7@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>> Persuading GCC to throw away *all* the self-test data after running
>> it was surprisingly annoying.
>
> Yeah.  Props for making the attempt.

*Whew*.  I was worried I'd get upbraided for overoptimziation.

>> The one thing I'm not really sure about is what to do if the self-test
>> fails.  For now, I make the module_init function fail too.  Opinions?
>
> The printk should suffice - someone will notice it eventually.
> 
> Using KERN_ERR to report a failure might help draw attention to it.

I'm not sure what you mean by "might"; I already *do* report it as KERN_ERR.

If you think failing the module load is a bad idea, feel free to
modify the patch.
