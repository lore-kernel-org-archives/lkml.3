Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752992Ab3FXSBV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 14:01:21 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37843 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751435Ab3FXSBU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 14:01:20 -0400
Date: Mon, 24 Jun 2013 14:00:38 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Oleg Nesterov <oleg@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130624180038.GA5312@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>
References: <20130621195949.GA15519@redhat.com>
 <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <1372096391.18733.177.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1372096391.18733.177.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jun 24, 2013 at 01:53:11PM -0400, Steven Rostedt wrote:

 > > Also. watchdog_timer_fn() calls printk() only if it detects the
 > > lockup, so I assume you hit another one?
 > 
 > Probably.

Yeah, unfortunately it happened while I was travelling home to the box,
so I couldn't stop it after the first instance.

Hopefully better traces now that I'm in front of it.

	Dave
 
