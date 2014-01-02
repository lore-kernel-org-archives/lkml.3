Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751807AbaABPn0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 10:43:26 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:6733 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750914AbaABPnZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 10:43:25 -0500
X-IronPort-AV: E=Sophos;i="4.95,591,1384300800"; 
   d="scan'208";a="87070849"
Message-ID: <52C5891A.7040603@citrix.com>
Date: Thu, 2 Jan 2014 15:43:22 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 11/18] xen/pvh: Piggyback on PVHVM for event channels
 (v2)
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-12-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-12-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> PVH is a PV guest with a twist - there are certain things
> that work in it like HVM and some like PV. There is
> a similar mode - PVHVM where we run in HVM mode with
> PV code enabled - and this patch explores that.
> 
> The most notable PV interfaces are the XenBus and event channels.
> 
> We will piggyback on how the event channel mechanism is
> used in PVHVM - that is we want the normal native IRQ mechanism
> and we will install a vector (hvm callback) for which we
> will call the event channel mechanism.
> 
> This means that from a pvops perspective, we can use
> native_irq_ops instead of the Xen PV specific. Albeit in the
> future we could support pirq_eoi_map. But that is
> a feature request that can be shared with PVHVM.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

David
