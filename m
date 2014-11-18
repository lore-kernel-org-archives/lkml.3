Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933676AbaKRPMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 10:12:38 -0500
Received: from mail.skyhub.de ([78.46.96.112]:33927 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932634AbaKRPMe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 10:12:34 -0500
Date: Tue, 18 Nov 2014 16:12:31 +0100
From: Borislav Petkov <bp@alien8.de>
To: Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Cc: Stephane Eranian <eranian@google.com>, x86-ml <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, kan.liang@intel.com
Subject: Re: [PATCH v3 13/13] perf/x86: add syfs entry to disable HT bug
 workaround
Message-ID: <20141118151231.GA5238@pd.tnic>
References: <1416251225-17721-1-git-send-email-eranian@google.com>
 <1416251225-17721-14-git-send-email-eranian@google.com>
 <20141117230232.GC25157@pd.tnic>
 <CAHzUATiZPYNt5nQ82TmCGH9mz0-Y-T6UFdo+0xHpYNcMFBnfZw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CAHzUATiZPYNt5nQ82TmCGH9mz0-Y-T6UFdo+0xHpYNcMFBnfZw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 18, 2014 at 05:01:28PM +0200, Maria Dimakopoulou wrote:
> OK. We can call it perf_pmu_ht_bug_workaround to make this more
> explicit.

I think you should consider adding a more generic scheme from the
get-go, as Thomas suggested instead of a specific file. We need this
hammered out properly before it gets exposed as it is user-visible and
once it is out there, there's no changing.

And this is not the only CPU bug we'll be implementing workaround for in
the future so a generic scheme is the right way to go IMO.

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
