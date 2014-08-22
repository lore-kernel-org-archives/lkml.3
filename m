Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756178AbaHVLmx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 07:42:53 -0400
Received: from mga01.intel.com ([192.55.52.88]:56021 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166AbaHVLmw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 07:42:52 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,379,1406617200"; 
   d="scan'208";a="580365463"
Date: Fri, 22 Aug 2014 19:43:02 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Petr =?utf-8?Q?Ml=C3=A1dek?= <pmladek@suse.cz>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: rcu: Throttle rcu_try_advance_all_cbs() execution causes visible
 slowdown in ftrace switching
Message-ID: <20140822114302.GG27650@localhost>
References: <1383326384.6788.49.camel@pathway.suse.cz>
 <20140822033529.GA7541@localhost>
 <20140822083257.GI17334@pathway.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140822083257.GI17334@pathway.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 22, 2014 at 10:32:57AM +0200, Petr Mládek wrote:
> On Fri 2014-08-22 11:35:29, Fengguang Wu wrote:
> > Hi Petr,
> > 
> > Sorry for picking up this old thread, but I noticed your attached
> > ftrace test script and would like to ask for your permission to
> > include it in
> > 
> >         https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git
> > 
> > which is GPLv2. If you kindly agree, I'll run it actively for testing
> > the upstream linux kernels.
> 
> Sure. Feel free to use the test script under GPLv2 license.

Great, thank you very much!

Fengguang
