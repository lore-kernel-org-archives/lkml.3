Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750855AbaECEDf (ORCPT <rfc822;w@1wt.eu>);
	Sat, 3 May 2014 00:03:35 -0400
Received: from terminus.zytor.com ([198.137.202.10]:54976 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750702AbaECEDf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 3 May 2014 00:03:35 -0400
Message-ID: <53646A7E.8010400@zytor.com>
Date: Fri, 02 May 2014 21:03:10 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Andy Lutomirski <luto@amacapital.net>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        x86@kernel.org, Steven Rostedt <rostedt@goodmis.org>,
        Gleb Natapov <gleb@kernel.org>, Paolo Bonzini <pbonzini@redhat.com>
Subject: Re: [PATCH v2] x86: Return to kernel without IRET
References: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
In-Reply-To: <6cfe29821979c42cd812878e05577f69f99fafaf.1399074748.git.luto@amacapital.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/02/2014 04:53 PM, Andy Lutomirski wrote:
> On my box, this saves about 100ns on each interrupt and trap that
> happens while running in kernel space.  This speeds up my kernel_pf
> microbenchmark by about 17%.
> 
> Signed-off-by: Andy Lutomirski <luto@amacapital.net>

I'd really like to see a workload which would genuinely benefit before
adding more complexity.  Now... if we can determine that it doesn't harm
anything and would solve the NMI nesting problem cleaner than the
current solution, that would justify things, too...

	-hpa

