Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752680AbaKGQwa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 11:52:30 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:53428 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751243AbaKGQw2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 11:52:28 -0500
Date: Fri, 7 Nov 2014 11:52:25 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
Cc: jslaby@suse.cz, linux@arm.linux.org.uk, mingo@redhat.com, nsekhar@ti.com,
        stefano.stabellini@eu.citrix.com, christoffer.dall@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] arm: ftrace: Adds support for ftrace operations
Message-ID: <20141107115225.72bc6cbf@gandalf.local.home>
In-Reply-To: <1415372352-15664-1-git-send-email-jjhiblot@traphandler.com>
References: <1415372352-15664-1-git-send-email-jjhiblot@traphandler.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri,  7 Nov 2014 15:59:11 +0100
Jean-Jacques Hiblot <jjhiblot@traphandler.com> wrote:

> Hi all,
> 
> This patch adds support for ftrace operations on the ARM architecture.
> This support is needed by kgraft and possibly other ftrace-based tools.
> My goal is to have kgraft working on ARM and aarch64.

Can you add this to the change log of the patch. As that would be what
goes into git history. Because honestly, I had no idea what you meant
by "ftrace operations". If I don't understand that term, how can you
expect anyone else to?

> 
> I tested this patch with a toy implementation of kgraft for ARM and basic
> usage of function and function_graph tracers
> It doesn't show any problem with the ftrace selftests and the tests found
> today in branch ftrace/testing-mystuff of linux-trace repository
> (git://git.kernel.org/pub/scm/linux/kernel/git/rostedt/linux-trace.git)

Those tests are no where near what I have. Does this code work on the
beagle bone white? If so, I can probably run my full suite on it.

-- Steve

> 
> Jean-Jacques Hiblot (1):
>   arm: ftrace: Adds support for ftrace operations
> 
>  arch/arm/Kconfig               |  2 ++
>  arch/arm/include/asm/ftrace.h  |  3 ++
>  arch/arm/kernel/entry-common.S | 68 +++++++++++++++++++++++++++++++++++++++++-
>  arch/arm/kernel/ftrace.c       | 34 +++++++++++++++++++++
>  4 files changed, 106 insertions(+), 1 deletion(-)
> 

