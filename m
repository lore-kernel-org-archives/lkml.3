Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752484AbaJVPEo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 11:04:44 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.230]:16054 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751572AbaJVPEm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 11:04:42 -0400
Date: Wed, 22 Oct 2014 11:04:34 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Heiko Carstens <heiko.carstens@de.ibm.com>, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ftracetest: add kprobes on ftrace testcase
Message-ID: <20141022110434.0c47eb0a@gandalf.local.home>
In-Reply-To: <54464D18.5070807@hitachi.com>
References: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com>
	<1413802323-5297-2-git-send-email-heiko.carstens@de.ibm.com>
	<54462581.4050505@hitachi.com>
	<20141021115928.GB4161@osiris>
	<54464D18.5070807@hitachi.com>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.24; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 21 Oct 2014 21:10:00 +0900
Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com> wrote:


> Steven, could you pick this series to your tree?
> I think it is better to manage ftracetest testcases in one tree.

I can pick these up. Is it OK if it goes into the 3.19 queue? Or is
there some urgent need to get them into 3.18? As they are ftracetests,
it's not that big of a deal to get them in early, as it is highly
unlikely to break the kernel itself.

-- Steve
