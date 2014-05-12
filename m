Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758404AbaELTjP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 15:39:15 -0400
Received: from mail-qg0-f43.google.com ([209.85.192.43]:62417 "EHLO
	mail-qg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752818AbaELTjN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 15:39:13 -0400
Message-ID: <5371235F.3040600@linaro.org>
Date: Mon, 12 May 2014 15:39:11 -0400
From: David Long <dave.long@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Oleg Nesterov <oleg@redhat.com>
CC: Ingo Molnar <mingo@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, Denys Vlasenko <dvlasenk@redhat.com>,
        Jim Keniston <jkenisto@us.ibm.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org,
        Ananth N Mavinakayanahalli <ananth@in.ibm.com>
Subject: Re: [PATCH 0/1] (Was: cleanup DO_ERROR*() to prepare for uprobes
 fixes)
References: <20140508191140.GA16892@redhat.com> <20140512170822.GA28335@redhat.com>
In-Reply-To: <20140512170822.GA28335@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/12/14 13:08, Oleg Nesterov wrote:
> On 05/08, Oleg Nesterov wrote:
>>
>> But let me send the initial changes first for review. If they pass the review
>> and if nobody objects, I'd like to route them along with the pending uprobes
>> fixes.
>
> OK, nobody cares ;)
>
> So I am going to ask Ingo to pull these changes plus the following minor fix.
>
> To remind, I think that traps.c needs more cleanups: do_general_protection()
> and math_error() should be converted into DO_ERROR(), DIE_GPF should die, and
> the users of show_unhandled_signals() should be unified/cleanuped.
>
> Ananth, David, this is x86 specific, but at first glance powerpc/arm might
> want to use uprobe_get_trap_addr() too.
>
> Oleg.
>

Thanks for the heads-up.  I currently have a preliminary patch to use 
the PC LSB to identify Thumb-mode instructions on ARM but I don't think 
this adds any new hinderances to that in the intended use case.

-dl

