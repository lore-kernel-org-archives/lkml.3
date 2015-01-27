Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932474AbbA0BqB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 20:46:01 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37763 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932275AbbA0Bp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 20:45:58 -0500
Date: Tue, 27 Jan 2015 02:45:54 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: Andy Lutomirski <luto@amacapital.net>
Cc: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "xen-devel@lists.xenproject.org" <xen-devel@lists.xenproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        X86 ML <x86@kernel.org>, kvm list <kvm@vger.kernel.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Steven Rostedt <rostedt@goodmis.org>, Borislav Petkov <bp@suse.de>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jan Beulich <JBeulich@suse.com>
Subject: Re: [RFC v4 1/2] x86/xen: add xen_is_preemptible_hypercall()
Message-ID: <20150127014554.GC17887@wotan.suse.de>
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <1421972951-3940-2-git-send-email-mcgrof@do-not-panic.com> <CALCETrWXrVAFQix=R33+ixGA34AKO=kR+zUzyWyJY6DWf9gBEA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CALCETrWXrVAFQix=R33+ixGA34AKO=kR+zUzyWyJY6DWf9gBEA@mail.gmail.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 22, 2015 at 05:40:45PM -0800, Andy Lutomirski wrote:
> On Thu, Jan 22, 2015 at 4:29 PM, Luis R. Rodriguez
> <mcgrof@do-not-panic.com> wrote:
> > From: "Luis R. Rodriguez" <mcgrof@suse.com>
> >
> > On kernels with voluntary or no preemption we can run
> > into situations where a hypercall issued through userspace
> > will linger around as it addresses sub-operatiosn in kernel
> > context (multicalls). Such operations can trigger soft lockup
> > detection.
> 
> Looks reasonable.

I'll add a reviewed-by...

  LUis
