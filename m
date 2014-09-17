Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaIQRqB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 13:46:01 -0400
Received: from cpsmtpb-ews08.kpnxchange.com ([213.75.39.13]:51654 "EHLO
	cpsmtpb-ews08.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1756063AbaIQRqA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 13:46:00 -0400
Message-ID: <1410975957.31130.93.camel@x220>
Subject: Re: [PATCH] rcu: unify boost and kthread priorities
From: Paul Bolle <pebolle@tiscali.nl>
To: paulmck@linux.vnet.ibm.com
Cc: Clark Williams <clark.williams@gmail.com>, linux-kernel@vger.kernel.org
Date: Wed, 17 Sep 2014 19:45:57 +0200
In-Reply-To: <20140917171717.GC4723@linux.vnet.ibm.com>
References: <20140915100524.2cd80d2e@sluggy>
	 <20140916204156.GP4723@linux.vnet.ibm.com> <1410972543.31130.87.camel@x220>
	 <20140917171717.GC4723@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-3.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 17 Sep 2014 17:45:58.0395 (UTC) FILETIME=[3D1C94B0:01CFD29F]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-09-17 at 10:17 -0700, Paul E. McKenney wrote:
> On Wed, Sep 17, 2014 at 06:49:03PM +0200, Paul Bolle wrote:
> > There's a reference to CONFIG_RCU_BOOST_PRIO in
> > tools/testing/selftests/rcutorture/doc/TREE_RCU-kconfig.txt. It needs
> > updating too, doesn't it?
> 
> Good catch!
> 
> Also the one in tools/testing/selftests/rcutorture/configs/rcu/TREE03.

>From my local perl monstrosity:
	# ...  and Paul McKenney's rcutorture stuff (v3.14-rc+)
	if ($blob->[1] =~ /tools\/testing\/selftests\/rcutorture\/configs\/.*/) {

Ie, I've made that script ignore all references to Kconfig macros below
tools/testing/selftest/rcutorture/configs. Is that too crude?

> Fixed both, thank you!


Paul Bolle

