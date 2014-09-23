Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290AbaIWMCO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Sep 2014 08:02:14 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:33839 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751122AbaIWMCN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Sep 2014 08:02:13 -0400
Date: Tue, 23 Sep 2014 05:02:06 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Davidlohr Bueso <dbueso@suse.de>
Cc: mingo@kernel.org, linux-kernel@vger.kernel.org, bobby.prani@gmail.com,
        oleg@redhat.com, ard.biesheuvel@linaro.org, joe@perches.com,
        rostedt@goodmis.org
Subject: Re: [GIT PULL rcu/next] RCU commits for 3.18
Message-ID: <20140923120206.GV4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20140922214603.GA6356@linux.vnet.ibm.com>
 <1411458392.8304.2.camel@linux-t7sj.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411458392.8304.2.camel@linux-t7sj.site>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092312-6688-0000-0000-00000506F875
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 23, 2014 at 09:46:32AM +0200, Davidlohr Bueso wrote:
> Hi Paul,
> 
> On Mon, 2014-09-22 at 14:46 -0700, Paul E. McKenney wrote:
> > 4.	Torture-test updates.  These were posted to LKML at
> > 	https://lkml.org/lkml/2014/8/28/546 and at
> > 	https://lkml.org/lkml/2014/9/11/1114.
> 
> I was planning on sending you another batch of torture patches. Would
> you rather I hold off until the next merge window, or is it still ok to
> send?

Feel free to send them now, if you like.  The probability of my pushing
them into 3.18 is low, but if they are straightforward, I might do so.

(I am actually sending this pull request a bit later than I normally
do -- I usually try to send it about -rc5 time.)

							Thanx, Paul

