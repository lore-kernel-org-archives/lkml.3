Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753019Ab3GBG3Z (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 02:29:25 -0400
Received: from mout.gmx.net ([212.227.15.18]:56727 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750851Ab3GBG3Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 02:29:24 -0400
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX1+uHFFMiR2uVBs9wrgw0oAy4GNkZwBYvjCmt0PWu9
	ALD+iJMP5JDEnJ
Message-ID: <1372746555.7363.147.camel@marge.simpson.net>
Subject: Re: [PATCH] sched: smart wake-affine
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>, Alex Shi <alex.shi@intel.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Turner <pjt@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Ram Pai <linuxram@us.ibm.com>
Date: Tue, 02 Jul 2013 08:29:15 +0200
In-Reply-To: <51D2708C.1050901@linux.vnet.ibm.com>
References: <51A43B16.9080801@linux.vnet.ibm.com>
	 <51D25A80.8090406@linux.vnet.ibm.com>
	 <1372744486.7363.133.camel@marge.simpson.net>
	 <51D2708C.1050901@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-07-02 at 14:17 +0800, Michael Wang wrote:

> As Peter mentioned before, we currently need some solution like the
> buddy-idea, and when folks report regression (I suppose they won't...),
> we will have more data then.
> 
> So we could firstly try to regain the lost performance of pgbench, if it
> strip the benefit of other benchmarks, let's fix it, and at last we will
> have a real smart wake-affine and no one will complain ;-)

The idea is plenty simple (and the fastpath has a deep and abiding love
of simple) so the idea itself flies in my book.  It doesn't add as much
knowledge as may be nice to have, but if it adds enough to help pgbench
and ilk without harming others, cool.

-Mike

