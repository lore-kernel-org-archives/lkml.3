Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755257AbbAWLUh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:20:37 -0500
Received: from mail.skyhub.de ([78.46.96.112]:52220 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755094AbbAWLU3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:20:29 -0500
Date: Fri, 23 Jan 2015 12:20:24 +0100
From: Borislav Petkov <bp@alien8.de>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Jan Beulich <JBeulich@suse.com>, Andy Lutomirski <luto@amacapital.net>,
        David Drysdale <drysdale@google.com>,
        Steven Rostedt <rostedt@goodmis.org>, Tony Luck <tony.luck@intel.com>,
        linux-kernel@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Ingo Molnar <mingo@elte.hu>, "H. Peter Anvin" <hpa@linux.intel.com>,
        xen-devel@lists.xenproject.org
Subject: Re: [Resend Patch v4 12/16] smp, x86: Kill SMP single function call
 interrupt
Message-ID: <20150123112024.GD22635@pd.tnic>
References: <1421991416-20297-1-git-send-email-jiang.liu@linux.intel.com>
 <1421991416-20297-13-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1421991416-20297-13-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 23, 2015 at 01:36:51PM +0800, Jiang Liu wrote:
> Commit 9a46ad6d6df3b54 "smp: make smp_call_function_many() use logic
> similar to smp_call_function_single()" has unified the way to handle
> single and multiple cross-CPU function calls. Now only one interrupt
> is needed for architecture specific code to support generic SMP function
> call interfaces, so kill the redundant single function call interrupt.
> 
> Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
> Cc: Ingo Molnar <mingo@elte.hu>
> Cc: Steven Rostedt <rostedt@goodmis.org>
> Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

ECO tip #101: Trim your mails when you reply.
--
