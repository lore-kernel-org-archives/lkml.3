Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755144Ab3FFVGt (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Jun 2013 17:06:49 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:7435 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753111Ab3FFVGs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Jun 2013 17:06:48 -0400
X-Authority-Analysis: v=2.0 cv=fZsvOjsF c=1 sm=0 a=rXTBtCOcEpjy1lPqhTCpEQ==:17 a=mNMOxpOpBa8A:10 a=FhPyjkP5XFMA:10 a=5SG0PmZfjMsA:10 a=IkcTkHD0fZMA:10 a=meVymXHHAAAA:8 a=88RBMKXO98UA:10 a=20KFwNOVAAAA:8 a=3nbZYyFuAAAA:8 a=VwQbUJbxAAAA:8 a=HNSsSjKmI1R_uVuAXHQA:9 a=QEXdDO2ut3YA:10 a=EvKJbDF4Ut8A:10 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=LI9Vle30uBYA:10 a=rXTBtCOcEpjy1lPqhTCpEQ==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 74.67.115.198
Message-ID: <1370552806.9844.50.camel@gandalf.local.home>
Subject: Re: [PATCH -tip ] [BUGFIX] kprobes: Fix arch_prepare_kprobe to
 handle copy insn failures
From: Steven Rostedt <rostedt@goodmis.org>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, linux-kernel@vger.kernel.org,
        Ingo Molnar <mingo@kernel.org>, "Frank Ch. Eigler" <fche@redhat.com>,
        systemtap@sourceware.org, yrl.pp-manager.tt@hitachi.com
Date: Thu, 06 Jun 2013 17:06:46 -0400
In-Reply-To: <20130605031216.15285.2001.stgit@mhiramat-M0-7522>
References: <20130605031216.15285.2001.stgit@mhiramat-M0-7522>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-3 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2013-06-05 at 12:12 +0900, Masami Hiramatsu wrote:
> Fix arch_prepare_kprobe() to handle failures in copy instruction
> correctly. This fix is related to the previous fix: 8101376
> which made __copy_instruction return an error result if failed,
> but caller site was not updated to handle it. Thus, this is the
> other half of the bugfix.
> 
> This fix is also related to the following bug-report:
> 
>    https://bugzilla.redhat.com/show_bug.cgi?id=910649
> 
> Signed-off-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
> Cc: Frank Ch. Eigler <fche@redhat.com>
> Cc: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Steven Rostedt <rostedt@goodmis.org>

-- Steve

> Cc: Ingo Molnar <mingo@kernel.org>
> ---
>  arch/x86/kernel/kprobes/core.c |   14 ++++++++++----
>  1 file changed, 10 insertions(+), 4 deletions(-)
> 


