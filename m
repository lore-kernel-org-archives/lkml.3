Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751510Ab3LLF3b (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 00:29:31 -0500
Received: from mga09.intel.com ([134.134.136.24]:7209 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751346Ab3LLF3a (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 00:29:30 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,876,1378882800"; 
   d="scan'208";a="450969254"
Message-ID: <1386826168.21780.44.camel@dvhart-mobl4.amr.corp.intel.com>
Subject: Re: process 'stuck' at exit.
From: Darren Hart <dvhart@linux.intel.com>
To: Dave Jones <davej@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>, Oleg Nesterov <oleg@redhat.com>,
        Andrea Arcangeli <aarcange@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>
Date: Wed, 11 Dec 2013 21:29:28 -0800
In-Reply-To: <20131212042626.GA26700@redhat.com>
References: <alpine.DEB.2.02.1312102001090.28330@ionos.tec.linutronix.de>
	 <CA+55aFzLnheC6W+Db=-MVr6aR5UzP-c1Q1yk_aN-9gxSjUpANw@mail.gmail.com>
	 <20131210203559.GA1209@redhat.com> <20131210204925.GB27373@redhat.com>
	 <20131210213431.GA6342@redhat.com> <20131210214143.GG27373@redhat.com>
	 <CA+55aFwr2e5x13fA+QWjt=iJFmCcugFErdqaeeUtH4XPBExC6Q@mail.gmail.com>
	 <CA+55aFxLbFWhgzg=Rn0rhUpoOjbTE3QqUSxHTsCyk8GjDUFxJg@mail.gmail.com>
	 <alpine.DEB.2.02.1312102329201.28330@ionos.tec.linutronix.de>
	 <CA+55aFzhCSvc4Vy7tEC2K972h+vne6Y0QSekDDZbV_ATB-9mxw@mail.gmail.com>
	 <20131212042626.GA26700@redhat.com>
Organization: Intel
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-12-11 at 23:26 -0500, Dave Jones wrote:
> On Tue, Dec 10, 2013 at 02:48:52PM -0800, Linus Torvalds wrote:
>  
>  > Dave, can you re-create that trinity run and test that patch? I think
>  > we've got this
> 
> 24 hours later, all is well.  I think we can call this one done.
> 
> Tested-by: Dave Jones <davej@fedoraproject.org>

Thank you again for a fine preemptive bug catch Dave!

-- 
Darren Hart
Intel Open Source Technology Center
Yocto Project - Linux Kernel


