Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759250AbaJ3Lzp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:55:45 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.231]:38519 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1758922AbaJ3Lzn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:55:43 -0400
Date: Thu, 30 Oct 2014 07:55:41 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@infradead.org>, Rabin Vincent <rabin@rab.in>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@redhat.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tracing/syscalls: ignore numbers outside NR_syscalls'
 range
Message-ID: <20141030075541.3bbe3609@gandalf.local.home>
In-Reply-To: <20141030075223.721e23d6@gandalf.local.home>
References: <1414620418-29472-1-git-send-email-rabin@rab.in>
	<20141030082606.GA7945@infradead.org>
	<20141030101808.GO27405@n2100.arm.linux.org.uk>
	<20141030071039.37633bf5@gandalf.local.home>
	<20141030075223.721e23d6@gandalf.local.home>
X-Mailer: Claws Mail 3.10.1 (GTK+ 2.24.25; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 30 Oct 2014 07:52:23 -0400
Steven Rostedt <rostedt@goodmis.org> wrote:

 
> Bah, I misread the patch. I shouldn't read patches before having my
> morning coffee :-/
> 

That's what I get by reading email before doing my morning Physical
Therapy treatment.

I'm off to do my PT exercises and then have breakfast. I'll pull the
patch in today, test it out, and then push it off for 3.18-rcX.

Thanks,

-- Steve
