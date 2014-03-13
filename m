Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753162AbaCMGXj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 02:23:39 -0400
Received: from mail-ob0-f171.google.com ([209.85.214.171]:63040 "EHLO
	mail-ob0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752088AbaCMGXi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 02:23:38 -0400
MIME-Version: 1.0
In-Reply-To: <87lhwevk98.fsf@rustcorp.com.au>
References: <1394240425-11647-1-git-send-email-keescook@chromium.org>
	<1394240425-11647-3-git-send-email-keescook@chromium.org>
	<CAGXu5j+QoHH004usCiCfJU6DPQFnQ2gt3P4GDLS7Gx8Tz_gK+A@mail.gmail.com>
	<87y50fuei5.fsf@rustcorp.com.au>
	<CAGXu5j+Zto=D_UYgn6DLVcOQyB_8sAs86masY8iuDTU5ZEZ8OQ@mail.gmail.com>
	<87lhwevk98.fsf@rustcorp.com.au>
Date: Wed, 12 Mar 2014 23:23:37 -0700
X-Google-Sender-Auth: xPM7f8IT2KExLBHkCMi1LDr4Od4
Message-ID: <CAGXu5jJvbdLqCNwrbrV-k-j2-=mDuccoodu3OuQg6eEduCvkqQ@mail.gmail.com>
Subject: Re: [PATCH v2 2/2] kallsyms: handle special absolute symbols
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 8:40 PM, Rusty Russell <rusty@rustcorp.com.au> wrote:
> Kees Cook <keescook@chromium.org> writes:
>> Why not just do this with 0-base-address detection like my v2? That
>> would mean we don't need to remember to add this flag in the future to
>> imagined new architectures that might want this 0-based per_cpu
>> feature.
>
> Because future architectures will get this right and emit absolute
> symbols.  I hope!
>
> I'm swamped at the moment, but am hoping to investigate that for
> x86-64.  This is a stop-gap.

Okay, I'm convinced. :)

Acked-by: Kees Cook <keescook@chromium.org>

Thanks!

-Kees

-- 
Kees Cook
Chrome OS Security
