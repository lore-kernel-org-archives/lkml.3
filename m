Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752733Ab3CCGme (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 01:42:34 -0500
Received: from mga01.intel.com ([192.55.52.88]:31240 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750846Ab3CCGmd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 01:42:33 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,771,1355126400"; 
   d="scan'208";a="294060243"
Date: Sun, 3 Mar 2013 14:42:23 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Christopher Li <sparse@chrisli.org>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [trace:tip/perf/core 5/15] kernel/trace/trace_functions.c:79:16:
 sparse: incorrect type in initializer (different address spaces)
Message-ID: <20130303064223.GA20325@localhost>
References: <5131ad43.H709l5IR4X+pbvbq%fengguang.wu@intel.com>
 <1362229972.31874.7.camel@gandalf.local.home>
 <1362230122.31874.8.camel@gandalf.local.home>
 <20130302132330.GA15256@localhost>
 <CANeU7Qn4n5QpiEiFaiwR5if4yAaCiWMHneJ8gg26Jac-4tbZyw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANeU7Qn4n5QpiEiFaiwR5if4yAaCiWMHneJ8gg26Jac-4tbZyw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 02, 2013 at 10:12:40PM -0800, Christopher Li wrote:
> On Sat, Mar 2, 2013 at 5:23 AM, Fengguang Wu <fengguang.wu@intel.com> wrote:
> > That's it!  Verified with
> >
> >         make C=1 kernel/trace/trace_functions.o
> 
> You can use C=2 to run sparse without recompile the obj file.

Got it, thanks!

Fengguang
