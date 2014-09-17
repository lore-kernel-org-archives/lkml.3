Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755409AbaIQOm5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Sep 2014 10:42:57 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:28184 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754786AbaIQOmz convert rfc822-to-8bit
	(ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Sep 2014 10:42:55 -0400
Date: Wed, 17 Sep 2014 10:42:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: Petr =?ISO-8859-1?B?TWzhZGVr?= <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: rcu: Throttle rcu_try_advance_all_cbs() execution causes
 visible slowdown in ftrace switching
Message-ID: <20140917104251.0a3b29c9@gandalf.local.home>
In-Reply-To: <20140822114302.GG27650@localhost>
References: <1383326384.6788.49.camel@pathway.suse.cz>
	<20140822033529.GA7541@localhost>
	<20140822083257.GI17334@pathway.suse.cz>
	<20140822114302.GG27650@localhost>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8BIT
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 22 Aug 2014 19:43:02 +0800
Fengguang Wu <fengguang.wu@intel.com> wrote:

> On Fri, Aug 22, 2014 at 10:32:57AM +0200, Petr Mládek wrote:
> > On Fri 2014-08-22 11:35:29, Fengguang Wu wrote:
> > > Hi Petr,
> > > 
> > > Sorry for picking up this old thread, but I noticed your attached
> > > ftrace test script and would like to ask for your permission to
> > > include it in
> > > 
> > >         https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git
> > > 
> > > which is GPLv2. If you kindly agree, I'll run it actively for testing
> > > the upstream linux kernels.
> > 
> > Sure. Feel free to use the test script under GPLv2 license.
> 
> Great, thank you very much!
> 
> Fengguang

Sorry for the very late reply, I've been on vacation and then had some
medical issues.

Note, I'm working with Masami to include lots of ftrace tests that will
supersede this script. The tests will be included in
tools/testing/selftests. Look for the subject "ftracetest".

-- Steve
