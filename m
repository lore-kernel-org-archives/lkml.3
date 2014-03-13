Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751112AbaCMEik (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 00:38:40 -0400
Received: from ozlabs.org ([203.10.76.45]:44388 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750754AbaCMEii (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 00:38:38 -0400
From: Rusty Russell <rusty@rustcorp.com.au>
To: Kees Cook <keescook@chromium.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86\@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 2/2] kallsyms: handle special absolute symbols
In-Reply-To: <CAGXu5j+Zto=D_UYgn6DLVcOQyB_8sAs86masY8iuDTU5ZEZ8OQ@mail.gmail.com>
References: <1394240425-11647-1-git-send-email-keescook@chromium.org> <1394240425-11647-3-git-send-email-keescook@chromium.org> <CAGXu5j+QoHH004usCiCfJU6DPQFnQ2gt3P4GDLS7Gx8Tz_gK+A@mail.gmail.com> <87y50fuei5.fsf@rustcorp.com.au> <CAGXu5j+Zto=D_UYgn6DLVcOQyB_8sAs86masY8iuDTU5ZEZ8OQ@mail.gmail.com>
User-Agent: Notmuch/0.15.2 (http://notmuchmail.org) Emacs/23.4.1 (x86_64-pc-linux-gnu)
Date: Thu, 13 Mar 2014 14:10:35 +1030
Message-ID: <87lhwevk98.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Kees Cook <keescook@chromium.org> writes:
> Why not just do this with 0-base-address detection like my v2? That
> would mean we don't need to remember to add this flag in the future to
> imagined new architectures that might want this 0-based per_cpu
> feature.

Because future architectures will get this right and emit absolute
symbols.  I hope!

I'm swamped at the moment, but am hoping to investigate that for
x86-64.  This is a stop-gap.

Cheers,
Rusty.
