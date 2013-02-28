Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3B1IHJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 03:07:09 -0500
Received: from mout.gmx.net ([212.227.15.19]:50698 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750999Ab3B1IHG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 03:07:06 -0500
X-Authenticated: #14349625
X-Provags-ID: V01U2FsdGVkX18yPPpRcjcyAOV718uY1THN0XqB9UDAnWaI8GiGB8
	t6ikwbLzRxaHsf
Message-ID: <1362038816.4460.127.camel@marge.simpson.net>
Subject: Re: [RFC PATCH] sched: wakeup buddy
From: Mike Galbraith <efault@gmx.de>
To: Michael Wang <wangyun@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>, Paul Turner <pjt@google.com>,
        Alex Shi <alex.shi@intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ram Pai <linuxram@us.ibm.com>,
        "Nikunj A. Dadhania" <nikunj@linux.vnet.ibm.com>,
        Namhyung Kim <namhyung@kernel.org>
Date: Thu, 28 Feb 2013 09:06:56 +0100
In-Reply-To: <512F0A5C.8030405@linux.vnet.ibm.com>
References: <512EFB4B.5040204@linux.vnet.ibm.com>
	 <1362035917.4460.105.camel@marge.simpson.net>
	 <512F09D4.1020307@linux.vnet.ibm.com> <512F0A5C.8030405@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Y-GMX-Trusted: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-02-28 at 15:42 +0800, Michael Wang wrote:

> I mean could we say that more ops/sec means more works has been done?

Sure.  But it's fairly meaningless, it's all scheduler.  Real tasks do
more than schedule.

-Mike

