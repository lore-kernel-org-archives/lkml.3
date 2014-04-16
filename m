Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755222AbaDPJ2r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 05:28:47 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1755173AbaDPJ2o (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 05:28:44 -0400
Message-ID: <534E4D48.5050002@nod.at>
Date: Wed, 16 Apr 2014 11:28:40 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: the arch/x86 maintainers <x86@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        ak@linux.intel.com, Steven Rostedt <rostedt@goodmis.org>,
        Borislav Petkov <bp@alien8.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: WARNING: CPU: 2 PID: 1857 at arch/x86/kernel/smp.c:124
References: <534E49C8.7050206@nod.at> <20140416092146.GQ11182@twins.programming.kicks-ass.net>
In-Reply-To: <20140416092146.GQ11182@twins.programming.kicks-ass.net>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.04.2014 11:21, schrieb Peter Zijlstra:
> On Wed, Apr 16, 2014 at 11:13:44AM +0200, Richard Weinberger wrote:
>> Hi!
>>
>> On a new 8 core server I'm facing the following issue.
>> After an oops a warning triggers.
> 
> I think its fair to ignore everything _after_ an OOPS ;-)

The problem here is that I'm using pstore with the erst backend (ACPI APEI).
But it can only store a few KiB. So upon every oops it captures only the bogus
warning and the original one is lost.

Thanks,
//richard
