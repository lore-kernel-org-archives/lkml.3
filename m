Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752699Ab3FZTXq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 15:23:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63515 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751935Ab3FZTXp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 15:23:45 -0400
Date: Wed, 26 Jun 2013 21:18:53 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Dave Jones <davej@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        "Eric W. Biederman" <ebiederm@xmission.com>,
        Andrey Vagin <avagin@openvz.org>, Steven Rostedt <rostedt@goodmis.org>
Subject: Re: frequent softlockups with 3.10rc6.
Message-ID: <20130626191853.GA29049@redhat.com>
References: <20130621195949.GA15519@redhat.com> <20130622013731.GA22918@redhat.com> <20130622173129.GA29375@redhat.com> <20130622215905.GA28238@redhat.com> <20130623143634.GA2000@redhat.com> <20130623150603.GA32313@redhat.com> <20130623160452.GA11740@redhat.com> <20130624155758.GA5993@redhat.com> <20130624173510.GA1321@redhat.com> <20130625153520.GA7784@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130625153520.GA7784@redhat.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/25, Dave Jones wrote:
>
> Took a lot longer to trigger this time. (13 hours of runtime).

And _perhaps_ this means that 3.10-rc7 without 8aac6270 needs more
time to hit the same bug ;)

Dave, I am not going to "deny the problem". We should investigate it
anyway. And yes, 8aac6270 is not as trivial as it looks.

But so far it is absolutely unclear how it can trigger such a problem,
and none of the traces _look_ as if it should be blamed.

Probably I should try to reproduce too...

Oleg.

