Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755290Ab3GOS4i (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 14:56:38 -0400
Received: from mx1.redhat.com ([209.132.183.28]:15236 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755190Ab3GOS4g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 14:56:36 -0400
Date: Mon, 15 Jul 2013 14:56:24 -0400
From: Dave Jones <davej@redhat.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: nohz: Warn if the machine can not perform nohz_full
Message-ID: <20130715185624.GB1706@redhat.com>
Mail-Followup-To: Dave Jones <davej@redhat.com>,
	Steven Rostedt <rostedt@goodmis.org>,
	Frederic Weisbecker <fweisbec@gmail.com>,
	Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
References: <20130715170859.GA25570@redhat.com>
 <20130715171800.GD6442@somewhere>
 <20130715172423.GA27745@redhat.com>
 <20130715173848.GA1066@redhat.com>
 <1373914182.17876.165.camel@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1373914182.17876.165.camel@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jul 15, 2013 at 02:49:42PM -0400, Steven Rostedt wrote:
 
 > > And here's a Core Duo from circa 2008.
 > > http://paste.fedoraproject.org/25429/13739098/raw
 > > 
 > > Two for two so far. I get the feeling you guys are going to get a ton of these reports.
 > 
 > Hmm, we should only warn if the user tried to enable nohz-full via the
 > command line. But it looks like it warns even without enabling
 > nohz-full, which wasn't the desired effect.
 > 
 > I'll look at this, and send a patch to make sure the warning only
 > happens when the user tries to use nohz-full, and doesn't just compile
 > it in. The point of the patch is to not let the user think they have
 > nohz-full when they don't.

Is a printk not enough for that purpose ? Tainting the kernel is kinda anti-social.

	Dave

