Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754205Ab3BVGNp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:13:45 -0500
Received: from mout.gmx.net ([212.227.17.21]:51241 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751660Ab3BVGNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:13:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+ZBgB0ovKZWuy82cWU37J/JPM0ceC9j6g2UGgHFf
	GJTsLBE0YAePU2
Message-ID: <1361513617.5817.66.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 22 Feb 2013 07:13:37 +0100
In-Reply-To: <5127018E.9040200@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361427108.5861.41.camel@marge.simpson.net>
	 <5125C607.8090909@linux.vnet.ibm.com>
	 <1361434231.5861.61.camel@marge.simpson.net>
	 <5125E40D.6050006@linux.vnet.ibm.com>
	 <1361439789.5861.70.camel@marge.simpson.net>
	 <5126D9A2.8090404@linux.vnet.ibm.com>
	 <1361509372.5817.60.camel@marge.simpson.net>
	 <5127018E.9040200@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 13:26 +0800, Michael Wang wrote:

> Just confirm that I'm not on the wrong way, did the 1:N mode here means
> 1 task forked N threads, and child always talk with father?

Yes, one server, many clients.

-Mike

