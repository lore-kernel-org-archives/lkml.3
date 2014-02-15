Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752863AbaBOLBF (ORCPT <rfc822;w@1wt.eu>);
	Sat, 15 Feb 2014 06:01:05 -0500
Received: from gate.crashing.org ([63.228.1.57]:42345 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752737AbaBOLBD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 15 Feb 2014 06:01:03 -0500
Message-ID: <1392458402.10050.25.camel@pasglop>
Subject: Re: [PATCH 39/48] powerpc: Replace __get_cpu_var uses
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Mike Galbraith <bitbucket@online.de>
Cc: Steven Rostedt <rostedt@goodmis.org>, Christoph Lameter <cl@linux.com>,
        Tejun Heo <tj@kernel.org>, akpm@linuxfoundation.org,
        linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Paul Mackerras <paulus@samba.org>
Date: Sat, 15 Feb 2014 21:00:02 +1100
In-Reply-To: <1392450890.5517.49.camel@marge.simpson.net>
References: <20140214201841.826179349@linux.com>
	 <20140214201908.082769265@linux.com> <1392436208.10050.22.camel@pasglop>
	 <20140214232636.0a683ca0@gandalf.local.home>
	 <1392450890.5517.49.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2014-02-15 at 08:54 +0100, Mike Galbraith wrote:
> > > For some reason Im still getting these as attachments instead of inline
> > > in the email, which makes reviewing a major PITA. Christoph, I'm not
> > > sure what you are doing wrong here but you should consider fixing it :-)
> > 
> > Get a better email client ;-)
> 
> Yeah, evolution shows them inline just fine (thought you made it do bad
> things too, it couldn't save signed patches or such).

Evo 3.8.4 here and they show as attachements only... odd.

Ben.


