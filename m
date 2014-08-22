Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755923AbaHVIdC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Aug 2014 04:33:02 -0400
Received: from cantor2.suse.de ([195.135.220.15]:54641 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754517AbaHVIdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Aug 2014 04:33:00 -0400
Date: Fri, 22 Aug 2014 10:32:57 +0200
From: Petr =?iso-8859-1?Q?Ml=E1dek?= <pmladek@suse.cz>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Tibor Billes <tbilles@gmx.com>, Josh Triplett <josh@joshtriplett.org>,
        Steven Rostedt <rostedt@goodmis.org>, Jiri Kosina <jkosina@suse.cz>,
        linux-kernel@vger.kernel.org, Wanlong Gao <gaowanlong@cn.fujitsu.com>
Subject: Re: rcu: Throttle rcu_try_advance_all_cbs() execution causes visible
 slowdown in ftrace switching
Message-ID: <20140822083257.GI17334@pathway.suse.cz>
References: <1383326384.6788.49.camel@pathway.suse.cz>
 <20140822033529.GA7541@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140822033529.GA7541@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 2014-08-22 11:35:29, Fengguang Wu wrote:
> Hi Petr,
> 
> Sorry for picking up this old thread, but I noticed your attached
> ftrace test script and would like to ask for your permission to
> include it in
> 
>         https://git.kernel.org/cgit/linux/kernel/git/wfg/lkp-tests.git
> 
> which is GPLv2. If you kindly agree, I'll run it actively for testing
> the upstream linux kernels.

Sure. Feel free to use the test script under GPLv2 license.

Best Regards,
Petr
