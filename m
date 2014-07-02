Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752304AbaGBMsF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 08:48:05 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:37451 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751228AbaGBMsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 08:48:03 -0400
Date: Wed, 2 Jul 2014 08:47:58 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Tejun Heo <tj@kernel.org>
Cc: Jiri Slaby <jslaby@suse.cz>, Stephen Rothwell <sfr@canb.auug.org.au>,
        linux-kernel@vger.kernel.org, mingo@redhat.com,
        akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>
Subject: Re: kGraft to -next [was: 00/21 kGraft]
Message-ID: <20140702084758.48cb352f@gandalf.local.home>
In-Reply-To: <20140702123002.GA20071@mtj.dyndns.org>
References: <1403694329-3064-1-git-send-email-jslaby@suse.cz>
	<53B3F556.7050002@suse.cz>
	<20140702123002.GA20071@mtj.dyndns.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2 Jul 2014 08:30:02 -0400
Tejun Heo <tj@kernel.org> wrote:

> Hello,
> 
> On Wed, Jul 02, 2014 at 02:04:38PM +0200, Jiri Slaby wrote:
> > On 06/25/2014 01:05 PM, Jiri Slaby wrote:
> ...
> > > https://git.kernel.org/cgit/linux/kernel/git/jirislaby/kgraft.git/log/?h=kgraft
> > 
> > Stephen,
> > 
> > may I ask you to add the kGraft tree to -next?
> > 
> > git://git.kernel.org/pub/scm/linux/kernel/git/jirislaby/kgraft.git#kgraft
> 
> Do we have consensus on the approach?  I personally really don't like
> the fact that it's adding another aspect to kthread management which
> is difficult to get right and nearly impossible to verify
> automatically.
> 
> IIUC, there are three similar solutions.  What are the pros and cons
> of each?  Can we combine the different approaches?

Has this been agreed on to be accepted yet? I don't believe so.

linux-next is for code that will be going into the next release of the
kernel. Not for developmental code or code that is still being
discussed.

-- Steve

