Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754748AbaIBQAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:00:19 -0400
Received: from qmta13.emeryville.ca.mail.comcast.net ([76.96.27.243]:38483
	"EHLO qmta13.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754624AbaIBQAP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:00:15 -0400
Date: Tue, 2 Sep 2014 11:00:12 -0500 (CDT)
From: Christoph Lameter <cl@linux.com>
X-X-Sender: cl@gentwo.org
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: Re: [percpu] BUG: unable to handle kernel NULL pointer dereference
 at (null)
In-Reply-To: <20140902153403.GY5001@linux.vnet.ibm.com>
Message-ID: <alpine.DEB.2.11.1409021052400.10607@gentwo.org>
References: <20140902045830.GA11321@localhost> <20140902153403.GY5001@linux.vnet.ibm.com>
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2 Sep 2014, Paul E. McKenney wrote:

> Before this commit, raw_cpu_add_return() didn't build.  The commit
> didn't affect anything else.
>
> So I don't understand how anything could work before this commit and
> be broken after it.  Enlightenment?

Where is that raw_cpu_add_return statement?

grep does not match anything like that in kernel/rcu/*
and this_cpu_add_return is used extensively in the network subsystem for
statistics.
