Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752050AbaFEOGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:06:49 -0400
Received: from mail.skyhub.de ([78.46.96.112]:52656 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751233AbaFEOGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:06:48 -0400
Date: Thu, 5 Jun 2014 16:04:52 +0200
From: Borislav Petkov <bp@alien8.de>
To: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, ak@linux.intel.com, jolsa@redhat.com,
        zheng.z.yan@intel.com
Subject: Re: [PATCH 5/9] perf/x86: implement cross-HT corruption bug
 workaround
Message-ID: <20140605140452.GC16811@pd.tnic>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-6-git-send-email-eranian@google.com>
 <20140605134841.GL3213@twins.programming.kicks-ass.net>
 <CAHzUATjSd0Cio25RvwNaph0vFZYQB-pKBt=xz7C=_MhZvpFXxQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHzUATjSd0Cio25RvwNaph0vFZYQB-pKBt=xz7C=_MhZvpFXxQ@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 05:01:25PM +0300, Maria Dimakopoulou wrote:
> Are you saying it is illegal to call kmalloc() from
> this context?
> 
> kmalloc is needed because we need to allocate
> a new constraint struct since the static constraint
> cannot be modified.
> 
> Worst case we can statically allocate a second
> constraint struct in the event struct.

A: Because it messes up the order in which people normally read text.
Q: Why is top-posting such a bad thing?
A: Top-posting.
Q: What is the most annoying thing in e-mail?

Please do not top-post.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
