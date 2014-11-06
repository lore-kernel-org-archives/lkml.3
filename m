Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751302AbaKFN1l (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:27:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:17978 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751229AbaKFN1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:27:40 -0500
Date: Thu, 6 Nov 2014 08:27:28 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, kgdb-bugreport@lists.sourceforge.net,
        linux-kernel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH RESEND 3.18-rc3 v2 0/2] trace: kdb: Bug fixes for ftdump
Message-ID: <20141106082728.5d4b7161@gandalf.local.home>
In-Reply-To: <1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
References: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
	<1415277716-19419-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  6 Nov 2014 12:41:54 +0000
Daniel Thompson <daniel.thompson@linaro.org> wrote:

> This patchset makes it possible to use kdb's ftdump command without
> panicing, crashing or livelocking. The ftdump command cannot be used
> at all without these changes.
> 
> IIRC this patches are still pending Jason's ack.

I haven't heard from Jason in a long time. Is he still active?

-- Steve


> 
> Changes since v1:
> 
> * Fixed use-after-free problems in v1 by adding logic to NULL out
>   buffer_iter during free operations.
> 
> * Introduced a second patch to fix a live lock when trying to display
>   an empty trace buffer.
> 
> 
> Daniel Thompson (2):
>   trace: kdb: Fix kernel panic during ftdump
>   trace: kdb: Fix kernel livelock with empty buffers
> 
>  kernel/trace/trace_kdb.c | 21 +++++++++++++--------
>  1 file changed, 13 insertions(+), 8 deletions(-)
> 
> --
> 1.9.3

