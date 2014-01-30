Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753089AbaA3Qsp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Jan 2014 11:48:45 -0500
Received: from www.sr71.net ([198.145.64.142]:48368 "EHLO blackbird.sr71.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751816AbaA3Qsn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Jan 2014 11:48:43 -0500
Message-ID: <52EA8267.4020107@sr71.net>
Date: Thu, 30 Jan 2014 08:48:39 -0800
From: Dave Hansen <dave@sr71.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        linux-security-module@vger.kernel.org, linux-arch@vger.kernel.org,
        sfr@canb.auug.org.au, zohar@linux.vnet.ibm.com, linux@arm.linux.org.uk,
        monstr@monstr.eu, ralf@linux-mips.org, benh@kernel.crashing.org,
        paulus@samba.org, schwidefsky@de.ibm.com, heiko.carstens@de.ibm.com,
        lethal@linux-sh.org, x86@kernel.org, james.l.morris@oracle.com
Subject: Re: [PATCH] kconfig: consolidate arch-specific seccomp options
References: <20140129191011.8FB63DFA@viggo.jf.intel.com> <20140130085551.GB2024@gmail.com>
In-Reply-To: <20140130085551.GB2024@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/30/2014 12:55 AM, Ingo Molnar wrote:
>> > +	  This kernel feature is useful for number crunching applications
>> > +	  that may need to compute untrusted bytecode during their
>> > +	  execution. By using pipes or other transports made available to
> I'd change and simplify the first sentence to:
> 
>> > +	  This kernel feature is useful to sandbox runtimes that need
>> > +	  to execute untrusted machine code.
> Seccomp isn't primarily about number crunching anymore, and it's 
> definitely not about 'bytecode' in the classical sense either.

I'll change that if I need to send it again.  Otherwise, I'll leave it
to the folks who actually know something about the feature, which isn't me.

