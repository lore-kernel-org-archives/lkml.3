Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754564AbaLBLLY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 06:11:24 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:62200 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751523AbaLBLLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 06:11:22 -0500
X-IronPort-AV: E=Sophos;i="5.07,500,1413244800"; 
   d="scan'208";a="198795713"
Message-ID: <547D9E56.50708@citrix.com>
Date: Tue, 2 Dec 2014 11:11:18 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@suse.com>,
        David Vrabel <david.vrabel@citrix.com>
CC: Juergen Gross <jgross@suse.com>, Joerg Roedel <jroedel@suse.de>,
        <kvm@vger.kernel.org>, Davidlohr Bueso <dbueso@suse.de>,
        Peter Zijlstra <peterz@infradead.org>, <x86@kernel.org>,
        Oleg Nesterov <oleg@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jan Beulich <JBeulich@suse.com>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, Borislav Petkov <bp@suse.de>,
        Olaf Hering <ohering@suse.de>, Ingo Molnar <mingo@kernel.org>
Subject: Re: [Xen-devel] [PATCH] xen: privcmd: schedule() after private	hypercall
 when non CONFIG_PREEMPT
References: <1417040805-15857-1-git-send-email-mcgrof@do-not-panic.com>	<5476C66F.5040308@suse.com> <20141127183616.GV25677@wotan.suse.de>	<547C4CEF.1010603@citrix.com>	<20141201150546.GC25677@wotan.suse.de>	<547C86BF.2040705@citrix.com>	<CAB=NE6WPvCJnAfdbZqcw5pJtZrfxo0zQu6J2gpXp69G-UTtiUg@mail.gmail.com>	<547C8F30.1010306@citrix.com>	<20141201161905.GH25677@wotan.suse.de>	<547CB07C.1050507@citrix.com> <20141201223611.GM25677@wotan.suse.de>
In-Reply-To: <20141201223611.GM25677@wotan.suse.de>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 8bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/12/14 22:36, Luis R. Rodriguez wrote:
> 
> Then I do agree its a fair analogy (and find this obviously odd that how
> widespread cond_resched() is), we just don't have an equivalent for IRQ
> context, why not avoid the special check then and use this all the time in the
> middle of a hypercall on the return from an interrupt (e.g., the timer
> interrupt)?

http://lists.xen.org/archives/html/xen-devel/2014-02/msg01101.html

David
