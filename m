Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752001AbaLQK1u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Dec 2014 05:27:50 -0500
Received: from smtp.citrix.com ([66.165.176.89]:63860 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751772AbaLQK1s (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Dec 2014 05:27:48 -0500
X-IronPort-AV: E=Sophos;i="5.07,593,1413244800"; 
   d="scan'208";a="205272485"
Message-ID: <54915A85.10403@citrix.com>
Date: Wed, 17 Dec 2014 10:27:17 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <x86@kernel.org>, <xen-devel@lists.xensource.com>,
        <konrad.wilk@oracle.com>, <david.vrabel@citrix.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>, <mingo@redhat.com>,
        <hpa@zytor.com>, <mmarek@suse.cz>, <linux-kbuild@vger.kernel.org>
Subject: Re: [Xen-devel] [Patch V2 4/4] xen: use generated hypercall symbols
 in arch/x86/xen/xen-head.S
References: <1418809838-14123-1-git-send-email-jgross@suse.com> <1418809838-14123-5-git-send-email-jgross@suse.com>
In-Reply-To: <1418809838-14123-5-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/12/14 09:50, Juergen Gross wrote:
> Instead of manually list each hypercall in arch/x86/xen/xen-head.S
> use the auto generated symbol list.
> 
> This also corrects the wrong address of xen_hypercall_mca which was
> located 32 bytes higher than it should.
> 
> Symbol addresses have been verified to match the correct ones via
> objdump output.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
