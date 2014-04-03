Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751995AbaDCMJc (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 08:09:32 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.232]:62955 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751929AbaDCMJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 08:09:29 -0400
Date: Thu, 3 Apr 2014 08:09:26 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Li, Aubrey" <aubrey.li@linux.intel.com>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        LKML <linux-kernel@vger.kernel.org>, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Matthew Garrett <mjg59@srcf.ucam.org>
Subject: Re: [BUG] x86: reboot doesn't reboot
Message-ID: <20140403080926.0fe0c404@gandalf.local.home>
In-Reply-To: <533D001A.5030802@linux.intel.com>
References: <20140403021411.6236996f@gandalf.local.home>
	<070BEF4AC20468458C22969097656CD91163106C@shsmsx102.ccr.corp.intel.com>
	<533D001A.5030802@linux.intel.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 03 Apr 2014 14:30:50 +0800
"Li, Aubrey" <aubrey.li@linux.intel.com> wrote:


> May I know if "reboot=t" make any difference on your system with the change?

It appears it does. Yes, it boots with "reboot=t" with the patches
applied, and does not reboot without it.

-- Steve
