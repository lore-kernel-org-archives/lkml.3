Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752170AbaDCNmA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 09:42:00 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:27022 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752114AbaDCNl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 09:41:58 -0400
Date: Thu, 3 Apr 2014 09:41:55 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403094155.04cc00bc@gandalf.local.home>
In-Reply-To: <533D001A.5030802@linux.intel.com>
References: <20140403021411.6236996f@gandalf.local.home>
	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
	<533D001A.5030802@linux.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2014 14:30:50 +0800
"Li, Aubrey" <aubrey.li@linux.intel.com> wrote:


> May I know if "reboot=t" make any difference on your system with the change?

Is this the future fix? Or do you have patches for me to test. I'll be
happy to test any patches you have on this box. If you need to know
anything about this box, let me know and I'll run any command that
would help you.

Thanks,

-- Steve
