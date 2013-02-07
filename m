Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757841Ab3BGER1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 23:17:27 -0500
Received: from ozlabs.org ([203.10.76.45]:50736 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756414Ab3BGERX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 23:17:23 -0500
From: Rusty Russell <rusty@rustcorp.com.au>
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>, tglx@linutronix.de,
        peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, mingo@kernel.org
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>,
        akpm@linux-foundation.org, namhyung@kernel.org, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        rjw@sisk.pl, sbw@mit.edu, fweisbec@gmail.com, linux@arm.linux.org.uk,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linuxppc-dev@lists.ozlabs.org, netdev@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        walken@google.com
Subject: Re: [PATCH v5 00/45] CPU hotplug: stop_machine()-free CPU hotplug
In-Reply-To: <510FBC01.2030405@linux.vnet.ibm.com>
References: <20130122073210.13822.50434.stgit@srivatsabhat.in.ibm.com> <510FBC01.2030405@linux.vnet.ibm.com>
User-Agent: Notmuch/0.14 (http://notmuchmail.org) Emacs/23.4.1 (i686-pc-linux-gnu)
Date: Thu, 07 Feb 2013 14:44:27 +1030
Message-ID: <87haloiwv0.fsf@rustcorp.com.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

"Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com> writes:
> On 01/22/2013 01:03 PM, Srivatsa S. Bhat wrote:
>                  Avg. latency of 1 CPU offline (ms) [stop-cpu/stop-m/c latency]
>
> # online CPUs    Mainline (with stop-m/c)       This patchset (no stop-m/c)
>
>       8                 17.04                          7.73
>
>      16                 18.05                          6.44
>
>      32                 17.31                          7.39
>
>      64                 32.40                          9.28
>
>     128                 98.23                          7.35

Nice!  I wonder how the ARM guys feel with their quad-cpu systems...

Thanks!
Rusty.
