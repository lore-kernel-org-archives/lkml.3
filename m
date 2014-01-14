Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752127AbaANLAh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 06:00:37 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57642 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751500AbaANLAa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 06:00:30 -0500
Date: Tue, 14 Jan 2014 12:00:21 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mike Travis <travis@sgi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Jason Wessel <jason.wessel@windriver.com>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Hedi Berriche <hedi@sgi.com>, Russ Anderson <rja@sgi.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] PATCH: UV/NMI Fix tip/bot/kbuild test robot problems
Message-ID: <20140114110021.GV7572@laptop.programming.kicks-ass.net>
References: <20140114042407.913800664@asylum.americas.sgi.com>
 <20140114042408.283595833@asylum.americas.sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114042408.283595833@asylum.americas.sgi.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 13, 2014 at 10:24:09PM -0600, Mike Travis wrote:
> Fix some problems found by the kbuild test robot.
> 
> Signed-off-by: Mike Travis <travis@sgi.com>
> Reviewed-by: Hedi Berriche <hedi@sgi.com>

In general it is best to actually mention the issues the patch cures,
otherwise review is impossible, /me stares hard at Hedi.
