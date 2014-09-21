Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751388AbaIUNZb (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 09:25:31 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39454 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751060AbaIUNZ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 09:25:29 -0400
Date: Sun, 21 Sep 2014 06:25:12 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>, Omar Sandoval <osandov@osandov.com>,
        Chris Mason <clm@fb.com>, Josef Bacik <jbacik@fb.com>,
        linux-btrfs@vger.kernel.org, Josh Triplett <josh@joshtriplett.org>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        Lai Jiangshan <laijs@cn.fujitsu.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] Return a value from printk_ratelimited
Message-ID: <20140921132512.GI4723@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <cover.1411116672.git.osandov@osandov.com>
 <3629aa32fd3e434e41e5e5f4a97ab50adb8edcdc.1411116672.git.osandov@osandov.com>
 <20140919132123.418b276f@gandalf.local.home>
 <1411150553.24444.29.camel@joe-AO725>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411150553.24444.29.camel@joe-AO725>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14092113-0928-0000-0000-000005065889
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Sep 19, 2014 at 11:15:53AM -0700, Joe Perches wrote:
> On Fri, 2014-09-19 at 13:21 -0400, Steven Rostedt wrote:
> > On Fri, 19 Sep 2014 02:01:29 -0700
> > Omar Sandoval <osandov@osandov.com> wrote:
> > 
> > > printk returns an integer; there's no reason for printk_ratelimited to swallow
> > > it.
> 
> Except for the lack of usefulness of the return value itself.
> See: https://lkml.org/lkml/2009/10/7/275

When printk()'s return value is changed to void, then yes, we should
clearly change this code to match that.

So, I have to ask...  What happened to the patch later in that series
that was to remove the uses of the printk() return value?

							Thanx, Paul

