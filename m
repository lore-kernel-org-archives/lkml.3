Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965441AbaKNLQn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Nov 2014 06:16:43 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:33054 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965084AbaKNLQa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Nov 2014 06:16:30 -0500
X-IronPort-AV: E=Sophos;i="5.07,385,1413244800"; 
   d="scan'208";a="192807758"
Message-ID: <5465E483.7080802@citrix.com>
Date: Fri, 14 Nov 2014 11:16:19 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xensource.com>, <x86@kernel.org>,
        <linux-kernel@vger.kernel.org>, <mingo@redhat.com>,
        <david.vrabel@citrix.com>, <hpa@zytor.com>,
        <boris.ostrovsky@oracle.com>, <tglx@linutronix.de>
Subject: Re: [Xen-devel] [PATCH V3 2/8] xen: Delay remapping memory of pv-domain
References: <1415684626-18590-1-git-send-email-jgross@suse.com>	<1415684626-18590-3-git-send-email-jgross@suse.com>	<20141112214506.GA5922@laptop.dumpdata.com>	<54644E48.3040506@suse.com>	<20141113195605.GA13039@laptop.dumpdata.com> <54658ABF.5050708@suse.com>
In-Reply-To: <54658ABF.5050708@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 14/11/14 04:53, Juergen Gross wrote:
> 
> Using BUG() instead would make the code less complex. Do you really
> think xen_update_mem_tables() would ever fail in a sane system?
> 
> - set_phys_to_machine() would fail only on a memory shortage. Just
>   going on without adding more memory wouldn't lead to a healthy system,
>   I think.
> - The hypervisor calls would fail only in case of parameter errors.
>   This should never happen, so dying seems to be the correct reaction.
> 
> David, what do you think?

BUG() sounds fine.

David
