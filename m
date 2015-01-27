Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757712AbbA0If0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 03:35:26 -0500
Received: from mail.emea.novell.com ([130.57.118.101]:36597 "EHLO
	mail.emea.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752579AbbA0IfY convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:14:2>);
	Tue, 27 Jan 2015 03:35:24 -0500
Message-Id: <54C75BD60200007800059BDD@mail.emea.novell.com>
X-Mailer: Novell GroupWise Internet Agent 14.0.1 
Date: Tue, 27 Jan 2015 08:35:18 +0000
From: "Jan Beulich" <JBeulich@suse.com>
To: <david.vrabel@citrix.com>, "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Cc: "Andy Lutomirski" <luto@amacapital.net>, <rostedt@goodmis.org>,
        "Masami Hiramatsu" <masami.hiramatsu.pt@hitachi.com>, <x86@kernel.org>,
        "Thomas Gleixner" <tglx@linutronix.de>, <paulmck@linux.vnet.ibm.com>,
        <xen-devel@lists.xenproject.org>, <boris.ostrovsky@oracle.com>,
        <konrad.wilk@oracle.com>, "Ingo Molnar" <mingo@redhat.com>,
        "Luis Rodriguez" <Mcgrof@suse.com>, "Borislav Petkov" <bp@suse.de>,
        <kvm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>
Subject: Re: [PATCH v5 2/2] x86/xen: allow privcmd hypercalls to be
 preempted on 64-bit
References: <1422323467-16713-1-git-send-email-mcgrof@do-not-panic.com>
 <1422323467-16713-3-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1422323467-16713-3-git-send-email-mcgrof@do-not-panic.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 27.01.15 at 02:51, <mcgrof@do-not-panic.com> wrote:

Even if David told you this would be acceptable, I have to question
an abstract model of fixing issues on only 64-bit kernels - this may
be acceptable for distro purposes, but seems hardly the right
approach for upstream. If 32-bit ones are to become deliberately
broken, the XEN config option should become dependent on !X86_32.

Jan

