Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932099Ab3GVJpk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 05:45:40 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:7252 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753187Ab3GVJpj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 05:45:39 -0400
X-IronPort-AV: E=Sophos;i="4.89,718,1367971200"; 
   d="scan'208";a="36529421"
Date: Mon, 22 Jul 2013 10:45:35 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
CC: Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        <catalin.marinas@arm.com>, <xen-devel@lists.xensource.com>,
        <marc.zyngier@arm.com>, <konrad.wilk@oracle.com>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] xen/arm and xen/arm64: update xen_restart after
 ff701306cd49
In-Reply-To: <51EC4701.8020502@cogentembedded.com>
Message-ID: <alpine.DEB.2.02.1307221045200.4893@kaball.uk.xensource.com>
References: <1374420257-19467-1-git-send-email-stefano.stabellini@eu.citrix.com> <51EC4701.8020502@cogentembedded.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 22 Jul 2013, Sergei Shtylyov wrote:
> Hello.
> 
> On 21-07-2013 19:24, Stefano Stabellini wrote:
> 
> > Commit ff701306cd49 changes the prototype of arm_pm_restart.
> 
>    Please also specify the summary line of that commit in parens.

Good idea, I'll repost


> > Update xen_restart accordingly.
> 
> > Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> 
> WBR, Sergei
> 
