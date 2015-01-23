Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754947AbbAWBlJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 20:41:09 -0500
Received: from mail-la0-f53.google.com ([209.85.215.53]:36304 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754666AbbAWBlG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 20:41:06 -0500
MIME-Version: 1.0
In-Reply-To: <1421972951-3940-2-git-send-email-mcgrof@do-not-panic.com>
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <1421972951-3940-2-git-send-email-mcgrof@do-not-panic.com>
From: Andy Lutomirski <luto@amacapital.net>
Date: Thu, 22 Jan 2015 17:40:45 -0800
Message-ID: <CALCETrWXrVAFQix=R33+ixGA34AKO=kR+zUzyWyJY6DWf9gBEA@mail.gmail.com>
Subject: Re: [RFC v4 1/2] x86/xen: add xen_is_preemptible_hypercall()
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        "Luis R. Rodriguez" <mcgrof@suse.com>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <JBeulich@suse.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 4:29 PM, Luis R. Rodriguez
<mcgrof@do-not-panic.com> wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
>
> On kernels with voluntary or no preemption we can run
> into situations where a hypercall issued through userspace
> will linger around as it addresses sub-operatiosn in kernel
> context (multicalls). Such operations can trigger soft lockup
> detection.

Looks reasonable.

--Andy
