Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752100AbbAUIG5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 03:06:57 -0500
Received: from mail-wi0-f178.google.com ([209.85.212.178]:52466 "EHLO
	mail-wi0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750754AbbAUIGu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 03:06:50 -0500
Message-ID: <1421827607.5772.19.camel@marge.simpson.net>
Subject: Re: [LKP] [rcu] 00f5159aeb6: +55.3%
 will-it-scale.time.involuntary_context_switches
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Huang Ying <ying.huang@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        LKP ML <lkp@01.org>
Date: Wed, 21 Jan 2015 09:06:47 +0100
In-Reply-To: <20150121075254.GC9719@linux.vnet.ibm.com>
References: <1421825564.6126.29.camel@intel.com>
	 <20150121075254.GC9719@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2015-01-20 at 23:52 -0800, Paul E. McKenney wrote: 
> On Wed, Jan 21, 2015 at 03:32:44PM +0800, Huang Ying wrote:
> > FYI, we noticed the below changes on
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/paulmck/linux-rcu.git stall.2015.01.06a
> > commit 00f5159aeb68f08ce29597be86be87d6db0c1ba1 ("rcu: Run grace-period kthreads at real-time priority")
> 
> Glad this helps!

The way I read it, it's hurting by increasing context switches... but if
you'll need a boot param to turn it on in the future, this is moot :)

-Mike

