Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751648AbaECLYd (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 07:24:33 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:10221 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751121AbaECLYc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 07:24:32 -0400
Date: Sat, 3 May 2014 07:24:28 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Gleb Natapov <gleb@kernel.org>,
        Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
Message-ID: <20140503072428.54f89688@gandalf.local.home>
In-Reply-To: <53646A7E.8010400@zytor.com>
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
	<53646A7E.8010400@zytor.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 02 May 2014 21:03:10 -0700
"H. Peter Anvin" <hpa@zytor.com> wrote:

> 
> I'd really like to see a workload which would genuinely benefit before
> adding more complexity.  Now... if we can determine that it doesn't harm
> anything and would solve the NMI nesting problem cleaner than the
> current solution, that would justify things, too...
> 

As I stated before. It doesn't solve the NMI nesting problem. It only
handles page faults. We would have to implement this for breakpoint
return paths too. Is that a plan as well?

-- Steve
