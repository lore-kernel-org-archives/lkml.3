Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754310AbaJaRKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Oct 2014 13:10:00 -0400
Received: from mail-lb0-f179.google.com ([209.85.217.179]:53773 "EHLO
	mail-lb0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaJaRJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Oct 2014 13:09:58 -0400
MIME-Version: 1.0
In-Reply-To: <20141031150911.GO23531@worktop.programming.kicks-ass.net>
References: <cover.1414190806.git.luto@amacapital.net> <20141031150911.GO23531@worktop.programming.kicks-ass.net>
From: Andy Lutomirski <luto@amacapital.net>
Date: Fri, 31 Oct 2014 10:09:35 -0700
Message-ID: <CALCETrWR1UeBcPeqpPPOLgveeR_vbBBajuG+odFPMTn94ZTE8Q@mail.gmail.com>
Subject: Re: [PATCH v2 0/8] CR4 handling improvements
To: Peter Zijlstra <peterz@infradead.org>, kvm list <kvm@vger.kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>, Gleb Natapov <gleb@redhat.com>
Cc: Valdis Kletnieks <Valdis.Kletnieks@vt.edu>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Kees Cook <keescook@chromium.org>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Vince Weaver <vince@deater.net>, "hillf.zj" <hillf.zj@alibaba-inc.com>,
        X86 ML <x86@kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Oct 31, 2014 at 8:09 AM, Peter Zijlstra <peterz@infradead.org> wrote:
>
>
> This looks ok I suppose, although the x86 people should pass verdict on
> the first few patches.

Adding some KVM people, too.  Patches 2 and 3 affect KVM, and that
code has been buggy in the recent past.  They should mostly fix the
performance regression that the fix for CVE-2014-3690 caused.

For reference, the series is here:

http://thread.gmane.org/gmane.linux.kernel/1813271/focus=1818661

Patch 1 has already been applied.

--Andy

-- 
Andy Lutomirski
AMA Capital Management, LLC
