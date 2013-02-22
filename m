Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754303Ab3BVGUp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 01:20:45 -0500
Received: from mout.gmx.net ([212.227.17.20]:62458 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751058Ab3BVGUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 01:20:44 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX194aJM37OR4CGlAclvZrvjC9whgy8cJUDGpc5Bhyv
	z5hVYS2Z0+4rLk
Message-ID: <1361513971.5817.72.camel@marge.simpson.net>
Subject: Re: [RFC PATCH v3 0/3] sched: simplify the select_task_rq_fair()
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>, alex.shi@intel.com,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Fri, 22 Feb 2013 07:19:31 +0100
In-Reply-To: <51270AD9.9020908@linux.vnet.ibm.com>
References: <51079178.3070002@linux.vnet.ibm.com>
	 <20130220104958.GA9152@gmail.com> <5125A7C8.8020308@linux.vnet.ibm.com>
	 <1361442055.26780.3.camel@laptop> <5126D9E0.7040108@linux.vnet.ibm.com>
	 <1361509697.5817.65.camel@marge.simpson.net>
	 <51270AD9.9020908@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2013-02-22 at 14:06 +0800, Michael Wang wrote: 
> On 02/22/2013 01:08 PM, Mike Galbraith wrote:
> > On Fri, 2013-02-22 at 10:37 +0800, Michael Wang wrote:
> > 
> >> According to the testing result, I could not agree this purpose of
> >> wake_affine() benefit us, but I'm sure that wake_affine() is a terrible
> >> performance killer when system is busy.
> > 
> > (hm, result is singular.. pgbench in 1:N mode only?)
> 
> I'm not sure about how pgbench implemented, all I know is it will create
> several instance and access the database, I suppose no different from
> several threads access database (1 server and N clients?).

It's user switchable.

-Mike

