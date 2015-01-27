Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759564AbbA0UNG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 15:13:06 -0500
Received: from cantor2.suse.de ([195.135.220.15]:38953 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751020AbbA0UNC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 15:13:02 -0500
Date: Tue, 27 Jan 2015 21:12:59 +0100
From: "Luis R. Rodriguez" <mcgrof@suse.com>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Jan Beulich <JBeulich@suse.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>,
        Andy Lutomirski <luto@amacapital.net>, rostedt@goodmis.org,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>, x86@kernel.org,
        Thomas Gleixner <tglx@linutronix.de>, paulmck@linux.vnet.ibm.com,
        xen-devel@lists.xenproject.org, boris.ostrovsky@oracle.com,
        konrad.wilk@oracle.com, Ingo Molnar <mingo@redhat.com>,
        Borislav Petkov <bp@suse.de>, kvm@vger.kernel.org,
        linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5 2/2] x86/xen: allow privcmd hypercalls to be
	preempted on 64-bit
Message-ID: <20150127201259.GB19988@wotan.suse.de>
References: <1422323467-16713-1-git-send-email-mcgrof@do-not-panic.com> <1422323467-16713-3-git-send-email-mcgrof@do-not-panic.com> <54C75BD60200007800059BDD@mail.emea.novell.com> <54C76334.2080003@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54C76334.2080003@citrix.com>
User-Agent: Mutt/1.5.17 (2007-11-01)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 27, 2015 at 10:06:44AM +0000, David Vrabel wrote:
> On 27/01/15 08:35, Jan Beulich wrote:
> >>>> On 27.01.15 at 02:51, <mcgrof@do-not-panic.com> wrote:
> > 
> > Even if David told you this would be acceptable, I have to question
> > an abstract model of fixing issues on only 64-bit kernels - this may
> > be acceptable for distro purposes, but seems hardly the right
> > approach for upstream. If 32-bit ones are to become deliberately
> > broken, the XEN config option should become dependent on !X86_32.
> 
> I'd rather have something omitted (keeping the current behaviour) than
> something that has not been tested at all.
> 
> Obviously it would be preferable to to fix both 32-bit and 64-bit x86
> (and ARM as well) but I'm not going to block an important bug fix for
> the majority use case (64-bit x86).

The hunk for 32-bit should indeed only go in once we get a Tested-by.
Please let me know if there is anything else needed for this patch.

  Luis
