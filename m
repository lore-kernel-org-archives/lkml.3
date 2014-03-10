Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaCJMxw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 08:53:52 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57025 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598AbaCJMxt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 08:53:49 -0400
Date: Mon, 10 Mar 2014 13:53:19 +0100
From: Jiri Olsa <jolsa@redhat.com>
To: Fengguang Wu <fengguang.wu@intel.com>
Cc: LKML <linux-kernel@vger.kernel.org>, Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [reboot] WARNING: CPU: 0 PID: 112 at kernel/events/core.c:5655
 perf_swevent_add()
Message-ID: <20140310125319.GE26334@krava.redhat.com>
References: <20140308065153.GA30311@localhost>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140308065153.GA30311@localhost>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 02:51:53PM +0800, Fengguang Wu wrote:
> 
> Hi all,
> 
> This is a very old WARNING, too old to be bisectable. The below 3 different
> back traces show that it's always triggered by trinity at system reboot time.
> Any ideas to quiet it? Thank you!

hi,
is there cpu hotplug involved? like writing to:
  /sys/devices/system/cpu/cpu*/online

thanks,
jirka
