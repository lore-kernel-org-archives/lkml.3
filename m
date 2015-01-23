Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755243AbbAWLvP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 06:51:15 -0500
Received: from smtp.citrix.com ([66.165.176.89]:23545 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754972AbbAWLvM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 06:51:12 -0500
X-IronPort-AV: E=Sophos;i="5.09,453,1418083200"; 
   d="scan'208";a="219966832"
Message-ID: <54C235AD.5010202@citrix.com>
Date: Fri, 23 Jan 2015 11:51:09 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>,
        <xen-devel@lists.xenproject.org>
CC: <kvm@vger.kernel.org>, "Luis R. Rodriguez" <mcgrof@suse.com>,
        <x86@kernel.org>, <linux-kernel@vger.kernel.org>,
        <rostedt@goodmis.org>, <paulmck@linux.vnet.ibm.com>
Subject: Re: [Xen-devel] [RFC v4 0/2] x86/xen: add xen hypercall preemption
References: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com>
In-Reply-To: <1421972951-3940-1-git-send-email-mcgrof@do-not-panic.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23/01/15 00:29, Luis R. Rodriguez wrote:
> From: "Luis R. Rodriguez" <mcgrof@suse.com>
> 
> This v4 addresses some of the cleanups recommended and adds
> tracing option for when we do actually preempt a hypercall.
> I kept the NOKPROBE_SYMBOL() for now but did remove the 'notrace'
> stuff.
> 
> This goes out as RFC still as I have not been able to test 32-bit.
> Can anyone test that or at least confirm that the 32-bit point
> we do the upcall is definitely not on the IRQ stack?

You can omit fixing this for 32-bit guests (provided you note as such in
the commit message).

David
