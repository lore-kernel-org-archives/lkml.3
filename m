Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752732AbaKGN54 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Nov 2014 08:57:56 -0500
Received: from smtp.citrix.com ([66.165.176.89]:34673 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751910AbaKGN5y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Nov 2014 08:57:54 -0500
X-IronPort-AV: E=Sophos;i="5.07,332,1413244800"; 
   d="scan'208";a="189130667"
Message-ID: <545CCFDC.9020603@citrix.com>
Date: Fri, 7 Nov 2014 13:57:48 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Juergen Gross <jgross@suse.com>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <konrad.wilk@oracle.com>,
        <boris.ostrovsky@oracle.com>, <x86@kernel.org>, <tglx@linutronix.de>,
        <mingo@redhat.com>, <hpa@zytor.com>
Subject: Re: [PATCH V2 3/5] xen: Delay invalidating extra memory
References: <1415252853-7106-1-git-send-email-jgross@suse.com> <1415252853-7106-4-git-send-email-jgross@suse.com>
In-Reply-To: <1415252853-7106-4-git-send-email-jgross@suse.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/11/14 05:47, Juergen Gross wrote:
> When the physical memory configuration is initialized the p2m entries
> for not pouplated memory pages are set to "invalid". As those pages
> are beyond the hypervisor built p2m list the p2m tree has to be
> extended.
> 
> This patch delays processing the extra memory related p2m entries
> during the boot process until some more basic memory management
> functions are callable. This removes the need to create new p2m
> entries until virtual memory management is available.

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

But I would like a second reviewed by for all the patches in this series
since it's such a complex area.

David
