Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753898Ab3KPBF3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 20:05:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:37754 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753169Ab3KPBFU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 20:05:20 -0500
Date: Fri, 15 Nov 2013 17:05:28 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, mingo@kernel.org, laijs@cn.fujitsu.com,
        dipankar@in.ibm.com, akpm@linux-foundation.org,
        mathieu.desnoyers@efficios.com, josh@joshtriplett.org, niv@us.ibm.com,
        tglx@linutronix.de, peterz@infradead.org, rostedt@goodmis.org,
        dhowells@redhat.com, edumazet@google.com, darren@dvhart.com,
        fweisbec@gmail.com, sbw@mit.edu
Subject: Re: [PATCH tip/core/rcu 01/28] rcutorture: Add KVM-based test
 framework
Message-ID: <20131116010528.GA9112@kroah.com>
References: <20131116003517.GA31563@linux.vnet.ibm.com>
 <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384562141-32446-1-git-send-email-paulmck@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Nov 15, 2013 at 04:35:14PM -0800, Paul E. McKenney wrote:
> From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
> 
> This commit adds the test framework that I used to test RCU under KVM.
> This consists of a group of scripts and Kconfig fragments.
> 
> Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
> Cc: Greg KH <gregkh@linuxfoundation.org>

Yeah!  Thanks for following through on this, it will help me out a lot
in testing stable kernels.

Oh, one very minor comment on the patches, you should delete the address
of the FSF from your file headers, unless you want to track the office
movements of them for the next 40+ years.  We've been removing them from
kernel code where we notice them, as half of them are wrong, and I don't
want to have to go back and fix them again when they move again.

thanks,

greg k-h
