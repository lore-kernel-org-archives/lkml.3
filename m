Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759837Ab3D3Iug (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 04:50:36 -0400
Received: from mail-bk0-f51.google.com ([209.85.214.51]:54955 "EHLO
	mail-bk0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759725Ab3D3Iu2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 04:50:28 -0400
Date: Tue, 30 Apr 2013 10:50:24 +0200
From: Ingo Molnar <mingo@kernel.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: mingo@elte.hu, linux-kernel@vger.kernel.org, fweisbec@gmail.com,
        rostedt@goodmis.org, bp@alien8.de, arjan@linux.intel.com,
        khilman@linaro.org, cl@linux.com, tglx@linutronix.de,
        olivier.baetz@novasparks.com, rdunlap@infradead.org, bp@suse.de
Subject: Re: [GIT PULL rcu/doc] Reducing OS jitter from per-CPU kthreads
Message-ID: <20130430085024.GA23017@gmail.com>
References: <20130428000500.GA20113@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130428000500.GA20113@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Paul E. McKenney <paulmck@linux.vnet.ibm.com> wrote:

> Hello, Ingo,
> 
> This series includes documentation for reducing OS jitter due to
> per-CPU kthreads.  It is available in the git repository at:
> 
>   git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git rcu/doc
> 
> for you to fetch changes up to 49717cb40410fe4b563968680ff7c513967504c6:
> 
>   kthread: Document ways of reducing OS jitter due to per-CPU kthreads (2013-04-27 16:52:47 -0700)
> 
> 							Thanx, Paul
> 
> ----------------------------------------------------------------
> Paul E. McKenney (1):
>       kthread: Document ways of reducing OS jitter due to per-CPU kthreads
> 
>  Documentation/kernel-per-CPU-kthreads.txt | 202 ++++++++++++++++++++++++++++++
>  1 file changed, 202 insertions(+)
>  create mode 100644 Documentation/kernel-per-CPU-kthreads.txt

Pulled, thanks Paul!

	Ingo
