Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107AbaABQPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:15:05 -0500
Received: from smtp.citrix.com ([66.165.176.89]:53240 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751372AbaABQPD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:15:03 -0500
X-IronPort-AV: E=Sophos;i="4.95,591,1384300800"; 
   d="scan'208";a="89270213"
Message-ID: <52C59068.1040603@citrix.com>
Date: Thu, 2 Jan 2014 16:14:32 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12 10/18] xen/pvh: Update E820 to work with PVH (v2)
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com> <1388550945-25499-11-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-11-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> In xen_add_extra_mem() we can skip updating P2M as it's managed
> by Xen. PVH maps the entire IO space, but only RAM pages need
> to be repopulated.

So this looks minimal but I can't work out what PVH actually needs to do
here.  This code really doesn't need to be made any more confusing.

I don't understand why the guest hasn't been supplied with sensible
memory map that we can use as-is without playing all these games?

David
