Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753747Ab3G2JS5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Jul 2013 05:18:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:56688 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752166Ab3G2JSz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Jul 2013 05:18:55 -0400
Date: Mon, 29 Jul 2013 11:18:51 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: "H. Peter Anvin" <hpa@linux.intel.com>, mingo@kernel.org,
        linux-kernel@vger.kernel.org, masami.hiramatsu.pt@hitachi.com,
        rostedt@goodmis.org, tglx@linutronix.de, fengguang.wu@intel.com,
        tip-bot for Jiri Kosina <tipbot@zytor.com>,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:perf/core] kprobes/x86: Call out into INT3 handler directly
 instead of using notifier
In-Reply-To: <51F6327A.9090609@zytor.com>
Message-ID: <alpine.LNX.2.00.1307291116560.18809@pobox.suse.cz>
References: <alpine.LNX.2.00.1307231007490.14024@pobox.suse.cz> <tip-17f41571bb2c4a398785452ac2718a6c5d77180e@git.kernel.org> <51EFE5A8.1060109@linux.intel.com> <alpine.LNX.2.00.1307291106260.18809@pobox.suse.cz> <51F6327A.9090609@zytor.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 29 Jul 2013, H. Peter Anvin wrote:

> >> Please note that putting this patch in perf/core means x86/jumplabel is
> >> completely nonfunctional by itself.
> > 
> > I'd like to point out that this is still the case ... TIA,
> 
> What is?

17f41571bb2c4a is only in perf/core, x86/jumplabel is missing it. I am not 
sure about the tip workflow, but as it is now, x86/jumplabel is buggy, so 
it should be either fixed (by pulling 17f41571bb2c4a from perf/core) or 
removed, or somehow marked as broken ... ?

Not a big deal for me as long as perf/core is fine, but as you were 
mentioning it ...

Thanks,

-- 
Jiri Kosina
SUSE Labs
