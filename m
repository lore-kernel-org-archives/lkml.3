Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752385Ab3JQG7D (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 02:59:03 -0400
Received: from smtprelay0243.hostedemail.com ([216.40.44.243]:49434 "EHLO
	smtprelay.hostedemail.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750866Ab3JQG7B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 02:59:01 -0400
X-Session-Marker: 6A6F6540706572636865732E636F6D
X-Spam-Summary: 2,0,0,,d41d8cd98f00b204,joe@perches.com,:::::::::::::::::::::,RULES_HIT:41:355:379:541:599:960:973:988:989:1260:1261:1277:1311:1313:1314:1345:1359:1373:1437:1515:1516:1518:1534:1541:1593:1594:1711:1730:1747:1777:1792:1978:2393:2553:2559:2562:2828:3138:3139:3140:3141:3142:3352:3622:3865:3866:3867:3868:3870:3871:3872:3873:3874:4250:4321:4605:5007:6119:7652:9121:10004:10400:10848:11026:11232:11233:11473:11658:11914:12043:12438:12517:12519:12740:13069:13311:13357,0,RBL:none,CacheIP:none,Bayesian:0.5,0.5,0.5,Netcheck:none,DomainCache
X-HE-Tag: floor66_1428c80551d41
X-Filterd-Recvd-Size: 2279
Message-ID: <1381993136.22110.95.camel@joe-AO722>
Subject: Re: [PATCH v2 3/9] bitops: Introduce a more generic BITMASK macro
From: Joe Perches <joe@perches.com>
To: Chen Gong <gong.chen@linux.intel.com>
Cc: tony.luck@intel.com, bp@alien8.de, naveen.n.rao@linux.vnet.ibm.com,
        m.chehab@samsung.com, arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Thomas Winischhofer <thomas@winischhofer.net>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Tomi Valkeinen <tomi.valkeinen@ti.com>
Date: Wed, 16 Oct 2013 23:58:56 -0700
In-Reply-To: <20131017063059.GB14946@gchen.bj.intel.com>
References: <1381935366-11731-1-git-send-email-gong.chen@linux.intel.com>
	 <1381935366-11731-4-git-send-email-gong.chen@linux.intel.com>
	 <1381978749.22110.76.camel@joe-AO722>
	 <20131017063059.GB14946@gchen.bj.intel.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 2013-10-17 at 02:30 -0400, Chen Gong wrote:
> On Wed, Oct 16, 2013 at 07:59:09PM -0700, Joe Perches wrote:
[]
> > Maybe add a
> > 
> > BUILD_BUG_ON(__builtin_constant_p(l) && __builtin_constant_p(h) && \
> > 	     (h) < (l))
> > 
> No, if so, users can't use variables for this macro.

__builtin_constant_p checks for constants

Built-in Function: int __builtin_constant_p (exp)
        You can use the built-in function __builtin_constant_p to
        determine if a value is known to be constant at compile-time and
        hence that GCC can perform constant-folding on expressions
        involving that value. The argument of the function is the value
        to test. The function returns the integer 1 if the argument is
        known to be a compile-time constant and 0 if it is not known to
        be a compile-time constant. A return of 0 does not indicate that
        the value is not a constant, but merely that GCC cannot prove it
        is a constant with the specified value of the -O option. 
        


