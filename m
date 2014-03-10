Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753439AbaCJTHB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 15:07:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40270 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752994AbaCJTHA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 15:07:00 -0400
Date: Mon, 10 Mar 2014 12:06:57 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Kees Cook <keescook@chromium.org>
Cc: Rusty Russell <rusty@rustcorp.com.au>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/2] kallsyms: handle special absolute symbols
Message-Id: <20140310120657.80aa5569714e5b53c6662798@linux-foundation.org>
In-Reply-To: <1394240425-11647-1-git-send-email-keescook@chromium.org>
References: <1394240425-11647-1-git-send-email-keescook@chromium.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Mar 2014 17:00:23 -0800 Kees Cook <keescook@chromium.org> wrote:

> Handles 0-based per_cpu variables as being absolute so they are
> not relocated under kASLR on x86_64.
> 

Would it be prudent to revert 0f55159d091cb1e5 ("kallsyms: fix absolute
addresses for kASLR") then sort all this out for 3.15?

