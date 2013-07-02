Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751834Ab3GBFLe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Jul 2013 01:11:34 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:50616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750994Ab3GBFLd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Jul 2013 01:11:33 -0400
Message-ID: <1372741852.7363.110.camel@marge.simpson.net>
Subject: Re: [PATCH RFC nohz_full v2 2/7] nohz_full: Add rcu_dyntick data
 for scalable detection of all-idle state
From: Mike Galbraith <bitbucket@online.de>
To: paulmck@linux.vnet.ibm.com
Cc: Josh Triplett <josh@joshtriplett.org>, linux-kernel@vger.kernel.org,
        mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        niv@us.ibm.com, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        darren@dvhart.com, fweisbec@gmail.com, sbw@mit.edu
Date: Tue, 02 Jul 2013 07:10:52 +0200
In-Reply-To: <20130701191656.GR3773@linux.vnet.ibm.com>
References: <20130628200949.GA17458@linux.vnet.ibm.com>
	 <1372450222-19420-1-git-send-email-paulmck@linux.vnet.ibm.com>
	 <1372450222-19420-2-git-send-email-paulmck@linux.vnet.ibm.com>
	 <20130701153150.GB2923@leaf> <20130701155220.GL3773@linux.vnet.ibm.com>
	 <20130701181601.GA7964@jtriplet-mobl1>
	 <20130701182326.GQ3773@linux.vnet.ibm.com>
	 <20130701183412.GA18804@jtriplet-mobl1>
	 <20130701191656.GR3773@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:+Ivh9WrW0Y5kO3NZkSOh9UT+EYHWNEdZdf7rHOWDyY3
 j7aiZxFAA7LEuoosmQ+V486mBO91JbaZRYNISzeWufXouY64oi
 0SUT93+YXa4tSxmFc7aUSQ7NQLThjLGocQQEHaZzP7S28qfUP/
 Msg4L5UW3mVnse3mEPPZDplHeQ29yaqD7zNkSt3lJ5rO3IBK2W
 Zre5bbjARXI7RlE/LQvLGIbqm4XyV77dsf9eH5YoByywlwpH2t
 ZOcO5w4W1cuanRas7vjQSFy5+mJ1cgryw+z06pO5p/ufJbsv1y
 lTU6GFXn4DNGz2Mtz2XfyqBNBFfU++pG8B5fleoL+fP6PDrLQk
 TxPH3kX4CjT2oi60HUuv7YFYh1tcQpXPJy0fayUuUxaE73tCab
 5JO+RGRDYZ15Q==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-01 at 12:16 -0700, Paul E. McKenney wrote: 
> On Mon, Jul 01, 2013 at 11:34:13AM -0700, Josh Triplett wrote:

> > > > This also naturally raises the question "How can we let userspace get
> > > > accurate time without forcing a timer tick?".
> > > 
> > > We don't.  ;-)
> > 
> > We don't currently, hence my question about how we can. :)
> 
> Per-CPU atomic clocks?

Great idea, who needs timekeeping code. 

http://www.euronews.com/2013/04/02/swiss-sets-sights-on-miniscule-atomic-clock/

-Mike

