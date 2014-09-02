Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754770AbaIBQ4E (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:56:04 -0400
Received: from qmta04.emeryville.ca.mail.comcast.net ([76.96.30.40]:43510 "EHLO
	qmta04.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739AbaIBQ4B (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:56:01 -0400
Date: Tue, 2 Sep 2014 11:55:58 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [percpu] BUG: unable to handle kernel NULL pointer dereference
 at (null)
In-Reply-To: <20140902162110.GB5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409021155410.10607@gentwo.org>
References: <20140902045830.GA11321@localhost> <20140902153403.GY5001@linux.vnet.ibm.com> <alpine.DEB.2.11.1409021052400.10607@gentwo.org> <20140902162110.GB5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Paul E. McKenney wrote:

> Added by ac1bea85781e (sched,rcu: Make cond_resched() report RCU quiescent
> states), removed by 4a81e8328d379 (rcu: Reduce overhead of cond_resched()
> checks for RCU).  So, as you say, no effect on contemporary kernels.

Well not sure what to make out of all of this....

