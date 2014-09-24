Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754597AbaIXPH0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 11:07:26 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.229]:52270 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750940AbaIXPHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 11:07:22 -0400
Date: Wed, 24 Sep 2014 11:07:19 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Daniel Thompson <daniel.thompson@linaro.org>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        patches@linaro.org, linaro-kernel@lists.linaro.org,
        John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        kgdb-bugreport@lists.sourceforge.net,
        Jason Wessel <jason.wessel@windriver.com>
Subject: Re: [PATCH 3.17-rc4 v2 0/2] trace: kdb: Bug fixes for ftdump
Message-ID: <20140924110719.165b5b5b@gandalf.local.home>
In-Reply-To: <1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
References: <1410360247-13791-1-git-send-email-daniel.thompson@linaro.org>
	<1411554781-16751-1-git-send-email-daniel.thompson@linaro.org>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Is Jason Wessel still actively maintaining this?

I'd like an acked-by from the KDB maintainer before pulling this.

Thanks!

-- Steve


On Wed, 24 Sep 2014 11:32:59 +0100
Daniel Thompson <daniel.thompson@linaro.org> wrote:

> This patchset makes it possible to use kdb's ftdump command without
> panicing, crashing or livelocking.
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

