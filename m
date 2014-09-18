Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755400AbaIRMpj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Sep 2014 08:45:39 -0400
Received: from mga01.intel.com ([192.55.52.88]:41765 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751254AbaIRMpi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Sep 2014 08:45:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,547,1406617200"; 
   d="scan'208";a="593230059"
Date: Thu, 18 Sep 2014 20:45:31 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Petr =?utf-8?Q?Ml=C3=A1dek?= <pmladek@suse.cz>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org,
        Wanlong Gao <gaowanlong@cn.fujitsu.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Subject: Re: rcu: Throttle rcu_try_advance_all_cbs() execution causes visible
 slowdown in ftrace switching
Message-ID: <20140918124531.GA7546@localhost>
References: <1383326384.6788.49.camel@pathway.suse.cz>
 <20140822033529.GA7541@localhost>
 <20140822083257.GI17334@pathway.suse.cz>
 <20140822114302.GG27650@localhost>
 <20140917104251.0a3b29c9@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140917104251.0a3b29c9@gandalf.local.home>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

HI Steven,

On Wed, Sep 17, 2014 at 10:42:51AM -0400, Steven Rostedt wrote:
> On Fri, 22 Aug 2014 19:43:02 +0800
> Fengguang Wu <fengguang.wu@intel.com> wrote:
> 
> > On Fri, Aug 22, 2014 at 10:32:57AM +0200, Petr Mládek wrote:
> > > On Fri 2014-08-22 11:35:29, Fengguang Wu wrote:
> > > > Hi Petr,
> > > > 
> > > > Sorry for picking up this old thread, but I noticed your attached
> > > > ftrace test script and would like to ask for your permission to
> > > > include it in
> > > > 
> > > >         https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git
> > > > 
> > > > which is GPLv2. If you kindly agree, I'll run it actively for testing
> > > > the upstream linux kernels.
> > > 
> > > Sure. Feel free to use the test script under GPLv2 license.
> > 
> > Great, thank you very much!
> > 
> > Fengguang
> 
> Sorry for the very late reply, I've been on vacation and then had some
> medical issues.
> 
> Note, I'm working with Masami to include lots of ftrace tests that will
> supersede this script. The tests will be included in
> tools/testing/selftests. Look for the subject "ftracetest".

Yes I just see the patches from Masami. We'll add them to the LKP
test suites. Thank you very much for letting me know!

Regards,
Fengguang

