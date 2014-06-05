Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751591AbaFEN3k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 09:29:40 -0400
Received: from mail.skyhub.de ([78.46.96.112]:45008 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750860AbaFEN3i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 09:29:38 -0400
Date: Thu, 5 Jun 2014 15:27:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Stephane Eranian <eranian@google.com>
Cc: Matt Fleming <matt@console-pimps.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, "mingo@elte.hu" <mingo@elte.hu>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Jiri Olsa <jolsa@redhat.com>, "Yan, Zheng" <zheng.z.yan@intel.com>,
        Maria Dimakopoulou <maria.n.dimakopoulou@gmail.com>
Subject: Re: [PATCH 9/9] perf/x86: add syfs entry to disable HT bug workaround
Message-ID: <20140605132750.GA16811@pd.tnic>
References: <1401917658-26065-1-git-send-email-eranian@google.com>
 <1401917658-26065-10-git-send-email-eranian@google.com>
 <CADknwL5S8QpzCAgrKHjbGTbEx7nA8L=Vu8d-UWAYCg6X25OcGw@mail.gmail.com>
 <CABPqkBSimH8Ob_q3dDtQiW_OwuS9nA4Gsx87H26ywNcmYd38Xw@mail.gmail.com>
 <CADknwL6s2ttb5E2JDr6bc_XkwpxnW5ecU-3Ns88=gvgPvLYkPg@mail.gmail.com>
 <CABPqkBQUUb+yEvC8y3oLc0DUbF3DJPzbt3sNL7Zqzufh6EYdRw@mail.gmail.com>
 <CADknwL71NC5wBG1tnqgJ6iiA4y+HYomGpufOn7V+MP2=m7+Mig@mail.gmail.com>
 <CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <CABPqkBTEafZ5MbYM4UQxX92uWcPiphPeXMoJRKTt8jnrB+5j2w@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 05, 2014 at 02:02:51PM +0200, Stephane Eranian wrote:
> It is enabled by default. Nothing is done to try and disable it later
> even once the kernel is fully booted. So this is mostly for testing
> and power-users.

You keep saying "power-users". What is the disadvantage for power users
running with the workaround disabled? I.e., why would anyone want to
disable it at all, what is the use case for that?

Thanks.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
