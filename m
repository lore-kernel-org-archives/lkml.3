Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754502AbaDNQEm (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Apr 2014 12:04:42 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:15798 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751369AbaDNQEl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Apr 2014 12:04:41 -0400
Date: Mon, 14 Apr 2014 12:04:36 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        mjg59@srcf.ucam.org, aubrey.li@linux.intel.com, tglx@linutronix.de,
        Borislav Petkov <bp@alien8.de>, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/urgent] [PATCH] x86: Try the BIOS reboot method before
 the PCI reboot method
Message-ID: <20140414120436.06f04c62@gandalf.local.home>
In-Reply-To: <20140414112714.GC4050@gmail.com>
References: <20140404064120.GB11877@gmail.com>
	<tip-f042310bf8a846bcf21012ffee78d9eb562a7fa4@git.kernel.org>
	<20140414112714.GC4050@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 14 Apr 2014 13:27:14 +0200
Ingo Molnar <mingo@kernel.org> wrote:

> So I rebased the patch Steve tested as-is and only fixed the patch 
> description and some comments in the code, preserving Steve's testing 
> status, and propagated it into x86/urgent.

I pulled your latest x86/urgent branch, booted it and then rebooted it.
Worked fine. Then I did a "git show | patch -p1 -R" rebuilt, rebooted,
and then reboot again, and it locked up.

Using commit f042310bf8a846bcf21012ffee78d9eb562a7fa4

-- Steve
