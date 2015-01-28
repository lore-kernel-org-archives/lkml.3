Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761745AbbA2Dk1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 22:40:27 -0500
Received: from casper.infradead.org ([85.118.1.10]:51062 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756601AbbA2BlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 20:41:23 -0500
Date: Wed, 28 Jan 2015 13:38:13 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Mark Rutland <mark.rutland@arm.com>
Cc: Fengguang Wu <fengguang.wu@intel.com>, LKP <lkp@01.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Ingo Molnar <mingo@redhat.com>, Paul Mackerras <paulus@samba.org>,
        Will Deacon <will.deacon@arm.com>
Subject: Re: [perf] WARNING: CPU: 0 PID: 1457 at kernel/events/core.c:890
 add_event_to_ctx()
Message-ID: <20150128123813.GE23038@twins.programming.kicks-ass.net>
References: <20150125043428.GA6109@wfg-t540p.sh.intel.com>
 <20150125155633.GA22257@leverpostej>
 <20150126184554.GM23313@leverpostej>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150126184554.GM23313@leverpostej>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 26, 2015 at 06:45:54PM +0000, Mark Rutland wrote:
> Peter, does the below patch look OK to you?

More or lessish, but its failing to apply on top of the broken patch.
Could you send me a fresh patch that's both rolled in one?
