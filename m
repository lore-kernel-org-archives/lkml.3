Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752208Ab3FWRvK (ORCPT <rfc822;w@1wt.eu>);
	Sun, 23 Jun 2013 13:51:10 -0400
Received: from mail-qc0-f171.google.com ([209.85.216.171]:51107 "EHLO
	mail-qc0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751777Ab3FWRvE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 23 Jun 2013 13:51:04 -0400
MIME-Version: 1.0
In-Reply-To: <20130623134516.19094.57189.stgit@srivatsabhat.in.ibm.com>
References: <20130623133642.19094.16038.stgit@srivatsabhat.in.ibm.com> <20130623134516.19094.57189.stgit@srivatsabhat.in.ibm.com>
From: Matt Turner <mattst88@gmail.com>
Date: Sun, 23 Jun 2013 10:50:42 -0700
Message-ID: <CAEdQ38HLzNoRABCUR7tEoBLJWn86xSd2VfSHxs0MPj5r5GvTXQ@mail.gmail.com>
Subject: Re: [PATCH 31/45] alpha/smp: Use get/put_online_cpus_atomic() to
 prevent CPU offline
To: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: tglx@linutronix.de, peterz@infradead.org, tj@kernel.org, oleg@redhat.com,
        paulmck@linux.vnet.ibm.com, rusty@rustcorp.com.au, mingo@kernel.org,
        akpm@linux-foundation.org, namhyung@kernel.org, walken@google.com,
        vincent.guittot@linaro.org, laijs@cn.fujitsu.com, rostedt@goodmis.org,
        wangyun@linux.vnet.ibm.com, xiaoguangrong@linux.vnet.ibm.com,
        sbw@mit.edu, fweisbec@gmail.com, zhong@linux.vnet.ibm.com,
        nikunj@linux.vnet.ibm.com, linux-pm@vger.kernel.org,
        linux-arch@vger.kernel.org, linuxppc-dev@lists.ozlabs.org,
        netdev@vger.kernel.org, linux-kernel@vger.kernel.org,
        Richard Henderson <rth@twiddle.net>,
        Ivan Kokshaysky <ink@jurassic.park.msu.ru>,
        linux-alpha@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jun 23, 2013 at 6:45 AM, Srivatsa S. Bhat
<srivatsa.bhat@linux.vnet.ibm.com> wrote:
> Once stop_machine() is gone from the CPU offline path, we won't be able
> to depend on disabling preemption to prevent CPUs from going offline
> from under us.
>
> Use the get/put_online_cpus_atomic() APIs to prevent CPUs from going
> offline, while invoking from atomic context.
>
> Also, remove the non-ASCII character present in this file!

It's not non-ASCII. It's a page break.
