Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752831Ab3FZTk5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:40:57 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752307Ab3FZTk4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:40:56 -0400
Date: Wed, 26 Jun 2013 15:40:39 -0400
From: Dave Jones <davej@redhat.com>
To: Oleg Nesterov <oleg@redhat.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130626194039.GA2833@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Oleg Nesterov <oleg@redhat.com>,
	"Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
	Linux Kernel <linux-kernel@vger.kernel.org>,
	Linus Torvalds <torvalds@linux-foundation.org>,
	"Eric W. Biederman" <ebiederm@xmission.com>,
	Andrey Vagin <avagin@openvz.org>,
	Steven Rostedt <rostedt@goodmis.org>
References: <20130622013731.GA22918@redhat.com>
 <20130622173129.GA29375@redhat.com>
 <20130622215905.GA28238@redhat.com>
 <20130623143634.GA2000@redhat.com>
 <20130623150603.GA32313@redhat.com>
 <20130623160452.GA11740@redhat.com>
 <20130624155758.GA5993@redhat.com>
 <20130624173510.GA1321@redhat.com>
 <20130625153520.GA7784@redhat.com>
 <20130626191853.GA29049@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130626191853.GA29049@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 26, 2013 at 09:18:53PM +0200, Oleg Nesterov wrote:
 > On 06/25, Dave Jones wrote:
 > >
 > > Took a lot longer to trigger this time. (13 hours of runtime).
 > 
 > And _perhaps_ this means that 3.10-rc7 without 8aac6270 needs more
 > time to hit the same bug ;)
 > 
 > Dave, I am not going to "deny the problem". We should investigate it
 > anyway. And yes, 8aac6270 is not as trivial as it looks.
 > 
 > But so far it is absolutely unclear how it can trigger such a problem,
 > and none of the traces _look_ as if it should be blamed.
 > 
 > Probably I should try to reproduce too...

I've tried so many different kernels this last week that I've forgotten
just how long I left the build without 8aac6270 running, but I'm pretty
sure it included an overnight run last weekend.  Given I have two identical
machines that can reproduce it, I'll leave one running for a few days
with that reverted just to see if it turns up.

(Though, I seem to be walking into other issues [like the perf overflow bug
 I reported last night] before seeing the lockups reproduce,  so I'll keep an eye on it).

	Dave
 
