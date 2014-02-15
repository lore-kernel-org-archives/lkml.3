Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752835AbaBOL34 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:29:56 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:64484 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752708AbaBOL3y (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:29:54 -0500
Message-ID: <1392463748.5517.56.camel@marge.simpson.net>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
From: Mike Galbraith <bitbucket@online.de>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Date: Sat, 15 Feb 2014 12:29:08 +0100
In-Reply-To: <1392458402.10050.25.camel@pasglop>
References: <20140214201841.826179349@linux.com>
	 <20140214201908.082769265@linux.com> <1392436208.10050.22.camel@pasglop>
	 <20140214232636.0a683ca0@gandalf.local.home>
	 <1392450890.5517.49.camel@marge.simpson.net>
	 <1392458402.10050.25.camel@pasglop>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
X-Provags-ID: V02:K0:DmoIjleV+svdN9ju5N8QaYVrSI4i3DopnmV4BbM5m+3
 /icvv6RMBbL+8jrqGnbF9buhQm0wPf4qMjbGKay31VK0PDEhjx
 o2TsDOJ3peJlLPsY0SWN3ukROkBgBGTYRVKrgngAQhf/VjRTq1
 9NFmLWiTEdxx3vmcc6xNT1J6g6/oOkCl6/1+jHi8g5/tZPd1qB
 uK+58gkQz+nAaDS7ea8IiCeS1jFXdMAKiSRi0Ih/J//HmwAJvs
 lI50Zu2fN2r8Utj3yR9i31vlc2qgGkhLw8GQnKNwl8o5SKbV+6
 qcHQQ5a/xU6Syhm7n3S3E095gICvDUJVT/gMOILzEoyjre2+kt
 DgRsScsRgP5ZT4BL3K0jvr4VQoZZE5DWeuytO/qC7WA6Jpc0er
 lW/oaOz5RiKIw==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-15 at 21:00 +1100, Benjamin Herrenschmidt wrote: 
> On Sat, 2014-02-15 at 08:54 +0100, Mike Galbraith wrote:
> > > > For some reason Im still getting these as attachments instead of inline
> > > > in the email, which makes reviewing a major PITA. Christoph, I'm not
> > > > sure what you are doing wrong here but you should consider fixing it :-)
> > > 
> > > Get a better email client ;-)
> > 
> > Yeah, evolution shows them inline just fine (thought you made it do bad
> > things too, it couldn't save signed patches or such).
> 
> Evo 3.8.4 here and they show as attachements only... odd.

Heh, 3.2.3 here.  I may never "upgrade" this box again.  No daemon from
hell, no grub2, everything including evolution (ok, mostly) just works.

-Mike

