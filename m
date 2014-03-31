Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751598AbaCaXgD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 19:36:03 -0400
Received: from mx1.redhat.com ([209.132.183.28]:23148 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751032AbaCaXgC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 19:36:02 -0400
Date: Mon, 31 Mar 2014 19:35:52 -0400
From: Dave Jones <davej@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Linux Kernel <linux-kernel@vger.kernel.org>
Subject: Re: rcu_prempt stalls / lockup
Message-ID: <20140331233552.GB30019@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>
References: <20140331230241.GA30019@redhat.com>
 <20140331232220.GP4284@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140331232220.GP4284@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Mar 31, 2014 at 04:22:21PM -0700, Paul E. McKenney wrote:
 > On Mon, Mar 31, 2014 at 07:02:41PM -0400, Dave Jones wrote:
 > > You can tell the merge window is open, because I'm back to breaking RCU.
 > > 
 > > ... 
 > > [ 3558.120739] INFO: Stall ended before state dump start
 > > 
 > > at that point, userspace stopped responding. cursor on console was blinking,
 > > but I couldn't even switch tty's, or sysrq dump.
 > > 
 > > rc8 was fine, so this is todays rcu changes.
 > 
 > New one on me!  Any chance of a .config file?

http://paste.fedoraproject.org/90449/30888213/raw/

	Dave

