Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758048AbbA0KB2 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 05:01:28 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:7874 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755361AbbA0KBX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 05:01:23 -0500
X-IronPort-AV: E=Sophos;i="5.09,473,1418083200"; 
   d="scan'208";a="221811084"
Message-ID: <54C761EE.6070507@citrix.com>
Date: Tue, 27 Jan 2015 10:01:18 +0000
From: Andrew Cooper <andrew.cooper3@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.3.0
MIME-Version: 1.0
To: Jan Beulich <JBeulich@suse.com>, <david.vrabel@citrix.com>,
        "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
CC: Borislav Petkov <bp@suse.de>, <kvm@vger.kernel.org>,
        Luis Rodriguez <Mcgrof@suse.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        <xen-devel@lists.xenproject.org>, Thomas Gleixner <tglx@linutronix.de>,
        <paulmck@linux.vnet.ibm.com>, <boris.ostrovsky@oracle.com>
Subject: Re: [Xen-devel] [PATCH v5 2/2] x86/xen: allow privcmd hypercalls
 to be preempted on 64-bit
References: <1422323467-16713-1-git-send-email-mcgrof@do-not-panic.com>	<1422323467-16713-3-git-send-email-mcgrof@do-not-panic.com> <54C75BD60200007800059BDD@mail.emea.novell.com>
In-Reply-To: <54C75BD60200007800059BDD@mail.emea.novell.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 27/01/15 08:35, Jan Beulich wrote:
>>>> On 27.01.15 at 02:51, <mcgrof@do-not-panic.com> wrote:
> Even if David told you this would be acceptable, I have to question
> an abstract model of fixing issues on only 64-bit kernels - this may
> be acceptable for distro purposes, but seems hardly the right
> approach for upstream. If 32-bit ones are to become deliberately
> broken, the XEN config option should become dependent on !X86_32.

There are still legitimate reasons to prefer 32bit PV guests over 64bit
ones.  Previous versions of this patch had 32bit support as well.  Why
did you drop it?

~Andrew
