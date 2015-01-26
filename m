Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756094AbbAZKr5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 05:47:57 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:31824 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754662AbbAZKrw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 05:47:52 -0500
X-IronPort-AV: E=Sophos;i="5.09,468,1418083200"; 
   d="scan'208";a="221482449"
Message-ID: <54C61B54.2060309@citrix.com>
Date: Mon, 26 Jan 2015 10:47:48 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>
CC: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <xen-devel@lists.xenproject.org>,
        Borislav Petkov <bp@suse.de>, <kvm@vger.kernel.org>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <rostedt@goodmis.org>,
        Andy Lutomirski <luto@amacapital.net>, Ingo Molnar <mingo@redhat.com>,
        Jan Beulich <JBeulich@suse.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Thomas Gleixner <tglx@linutronix.de>, <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [RFC v4 2/2] x86/xen: allow privcmd hypercalls to
 be preempted
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com> <1421972951-3940-3-git-send-email-mcgrof@do-not-panic.com> <54C23442.9000008@citrix.com> <20150123185812.GX17887@wotan.suse.de>
In-Reply-To: <20150123185812.GX17887@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 18:58, Luis R. Rodriguez wrote:
> 
> Its not just hypercalls though, this is all about the interactions
> with multicalls no?

No.  This applies to any preemptible hypercall and the toolstack doesn't
use multicalls for most of its work.

David
