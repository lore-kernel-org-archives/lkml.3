Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761650Ab3JQSlV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 14:41:21 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:40154 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758245Ab3JQSlU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 14:41:20 -0400
Date: Thu, 17 Oct 2013 14:41:16 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "Arend van Spriel" <arend@broadcom.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: trace-cmd problem with FC19
Message-ID: <20131017144116.044f3aaf@gandalf.local.home>
In-Reply-To: <525FD328.1040204@broadcom.com>
References: <525FD328.1040204@broadcom.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 17 Oct 2013 14:08:08 +0200
"Arend van Spriel" <arend@broadcom.com> wrote:

> Hi Steven,
> 
> When tracing I get these error messages and no trace data is recorded. I 
> also cloned the trace-cmd repo and tried that with the same result. I 
> think the kernel configuration looks ok, but adding it.
> 
> I use it almost daily on Ubuntu system, but trying Fedora for a change. 
> I do have a difference with kernel taint with my driver loaded:
> 
> Ubuntu	4096	(OOT module loaded, ie. my driver)
> Fedora	4098	(OOT *and* forced module?)
> 
> 'forced module' probably caused by:
> [10808.074823] Request for unknown module key 'Fedora kernel signing 
> key: 8661dbf3061bfa70eb76d61691cec200318534b4' err -11
> 
> Would that explain my issue?
> 
> Regards,
> Arend
> 
> ---8<----------------------------------------------------
> $ sudo trace-cmd record -e brcmfmac:*
> /sys/kernel/debug/tracing/events/brcmfmac/*/filter
> Hit Ctrl^C to stop recording
> ^Ctrace-cmd: Interrupted system call
> trace-cmd: Interrupted system call
>      recorder error in splice inputrecorder error in splice input

I haven't seen this before.

Was the brcmfmac module the one that was forced loaded?

Does recording other traces work? Or is it only spicific to this module?

-- Steve

> 
> trace-cmd: Interrupted system call
>    recorder error in splice input
> trace-cmd: Interrupted system call
>    recorder error in splice input
> Kernel buffer statistics:
>    Note: "entries" are the entries left in the kernel ring buffer and 
> are not
>          recorded in the trace data. They should all be zero.
> 

