Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757304Ab3J1RcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 13:32:06 -0400
Received: from e7.ny.us.ibm.com ([32.97.182.137]:53564 "EHLO e7.ny.us.ibm.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756645Ab3J1RcE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 13:32:04 -0400
Date: Mon, 28 Oct 2013 23:01:52 +0530
From: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
To: Pekka Enberg <penberg@iki.fi>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Hemant Kumar <hkshaw@linux.vnet.ibm.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Oleg Nesterov <oleg@redhat.com>,
        hegdevasant@linux.vnet.ibm.com, Ingo Molnar <mingo@redhat.com>,
        anton@redhat.com, systemtap@sourceware.org,
        Namhyung Kim <namhyung@kernel.org>, aravinda@linux.vnet.ibm.com
Subject: Re: [PATCH v4 2/3] Support for perf to probe into SDT markers:
Message-ID: <20131028173152.GB1040@linux.vnet.ibm.com>
Reply-To: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
References: <20131023044511.1886.82571.stgit@hemant-fedora>
 <20131023050502.1886.15779.stgit@hemant-fedora>
 <CAOJsxLFKm3TxeTmGjbpr1r4sZ8fHcM481-5BM_Cq0J8hhtvBqQ@mail.gmail.com>
 <526E4940.8000608@hitachi.com>
 <526E5BA5.7050103@iki.fi>
 <20131028141152.GA1040@linux.vnet.ibm.com>
 <526E72EC.9060400@iki.fi>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
In-Reply-To: <526E72EC.9060400@iki.fi>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13102817-5806-0000-0000-0000233D5409
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> >
> >But what if a system has both 32 bit libc and 64 bit libc?
> >Wont we could end up with 2 libc:setjmp?
> >Should we give some more intelligence into perf to choose the 64 bit
> >libc over 32 bit one?
> 
> You can just trace both of them by default, no?
> 

There has to be a one to one association with the event name and its
mapping.  Every event name will finally map to a unique inode and an
offset.

One option would be for perf to look at these markers and have a
different event name for similar markers in different executables. 

-- 
Thanks and Regards
Srikar Dronamraju

