Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932449AbaJUL7f (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Oct 2014 07:59:35 -0400
Received: from e06smtp12.uk.ibm.com ([195.75.94.108]:41037 "EHLO
	e06smtp12.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932283AbaJUL7d (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Oct 2014 07:59:33 -0400
Date: Tue, 21 Oct 2014 13:59:28 +0200
From: Heiko Carstens <heiko.carstens@de.ibm.com>
To: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Ingo Molnar <mingo@redhat.com>, Steven Rostedt <rostedt@goodmis.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/2] ftracetest: add kprobes on ftrace testcase
Message-ID: <20141021115928.GB4161@osiris>
References: <1413802323-5297-1-git-send-email-heiko.carstens@de.ibm.com>
 <1413802323-5297-2-git-send-email-heiko.carstens@de.ibm.com>
 <54462581.4050505@hitachi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54462581.4050505@hitachi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14102111-0009-0000-0000-0000019F4F3C
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 21, 2014 at 06:21:05PM +0900, Masami Hiramatsu wrote:
> (2014/10/20 19:52), Heiko Carstens wrote:
> > Add a kprobes on ftrace testcase. The testcase verifies that
> > - enabling and disabling function tracing works on a function which
> >   already contains a dynamic kprobe
> > - adding and removing a dynamic kprobe works on a function which is
> >   already enabled for function tracing
> > 
> 
> Looks good to me.
> 
> > Signed-off-by: Heiko Carstens <heiko.carstens@de.ibm.com>
> 
> Acked-by: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>

Hi Masami,

thanks! How should these two patches go upstream?

Thanks,
Heiko

