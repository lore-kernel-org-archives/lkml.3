Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759052Ab3FDGGp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 02:06:45 -0400
Received: from mga14.intel.com ([143.182.124.37]:42296 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751507Ab3FDGGn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 02:06:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,798,1363158000"; 
   d="scan'208";a="344387513"
Date: Tue, 4 Jun 2013 14:06:24 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [bisect done] [    0.000000] WARNING: at mm/nobootmem.c:215
 ___alloc_bootmem_nopanic.constprop.5()
Message-ID: <20130604060624.GA26167@localhost>
References: <20130603105754.GA6595@localhost>
 <20130604052240.GC11597@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130604052240.GC11597@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 03, 2013 at 10:22:40PM -0700, Paul E. McKenney wrote:
> On Mon, Jun 03, 2013 at 06:57:54PM +0800, Fengguang Wu wrote:
> > Greetings,
> > 
> > I got the below dmesg and the first bad commit is
> > 
> > commit 911af505ef407c2511106c224dd640f882f0f590
> > Author: Paul E. McKenney <paul.mckenney@linaro.org>
> > Date:   Mon Feb 11 10:23:27 2013 -0800
> 
> Hello, Fengguang,
> 
> This is now in mainline, as is the fix for this bug:
> 
> 615ee544 (rcu: Don't allocate bootmem from rcu_init())

Hi Paul,

Got it, thanks!

Thanks,
Fengguang
