Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755580AbaJ1IQt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 Oct 2014 04:16:49 -0400
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:35152 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751778AbaJ1IQq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 Oct 2014 04:16:46 -0400
Date: Tue, 28 Oct 2014 10:16:43 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Linux Kernel list <linux-kernel@vger.kernel.org>
Subject: Re: hung tasks in 3.18.0-rc1-00221-gc3351df
In-Reply-To: <20141027174424.GB27568@linux.vnet.ibm.com>
Message-ID: <alpine.LRH.2.11.1410281014530.6536@adalberg.ut.ee>
References: <alpine.LRH.2.11.1410231619340.11555@adalberg.ut.ee> <20141024001822.GK4977@linux.vnet.ibm.com> <alpine.LRH.2.11.1410241057270.15464@adalberg.ut.ee> <20141024145509.GO4977@linux.vnet.ibm.com> <20141027174424.GB27568@linux.vnet.ibm.com>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> rcu: Make rcu_barrier() understand about missing rcuo kthreads

I can not trigger the previous problem at will so my testing is not very 
useful. I tested the previous patch that you sent but the problem did 
not trigger, and yesterday applied this one and it still does not 
trigger, but I an using remote sessions only for now (no desktop).

At least it's not clearly broken :)

-- 
Meelis Roos (mroos@linux.ee)
