Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753584AbaCKCdP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 22:33:15 -0400
Received: from mga01.intel.com ([192.55.52.88]:33071 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751517AbaCKCdO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 22:33:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,628,1389772800"; 
   d="scan'208";a="489493411"
Date: Tue, 11 Mar 2014 10:33:12 +0800
From: Fengguang Wu <fengguang.wu@intel.com>
To: Jiri Olsa <jolsa@redhat.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [reboot] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655
 perf_swevent_add()
Message-ID: <20140311023312.GA9157@localhost>
References: <20140308065153.GA30311@localhost>
 <20140310125319.GE26334@krava.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140310125319.GE26334@krava.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jiri,

On Mon, Mar 10, 2014 at 01:53:19PM +0100, Jiri Olsa wrote:
> On Sat, Mar 08, 2014 at 02:51:53PM +0800, Fengguang Wu wrote:
> > 
> > Hi all,
> > 
> > This is a very old WARNING, too old to be bisectable. The below 3 different
> > back traces show that it's always triggered by trinity at system reboot time.
> > Any ideas to quiet it? Thank you!
> 
> hi,
> is there cpu hotplug involved? like writing to:
>   /sys/devices/system/cpu/cpu*/online

Yeah, we do run random CPU hotplug tests in the background.

Thanks,
Fengguang
