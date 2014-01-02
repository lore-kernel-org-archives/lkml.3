Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752096AbaABQuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 11:50:18 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:33096 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaABQuQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 11:50:16 -0500
X-IronPort-AV: E=Sophos;i="4.95,591,1384300800"; 
   d="scan'208";a="87095858"
Message-ID: <52C598C6.7040902@citrix.com>
Date: Thu, 2 Jan 2014 16:50:14 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <linux-kernel@vger.kernel.org>, <xen-devel@lists.xenproject.org>,
        <boris.ostrovsky@oracle.com>, <stefano.stabellini@eu.citrix.com>,
        <mukesh.rathor@oracle.com>
Subject: Re: [PATCH v12] Linux Xen PVH support.
References: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1388550945-25499-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/01/14 04:35, Konrad Rzeszutek Wilk wrote:
> The patches, also available at
> git://git.kernel.org/pub/scm/linux/kernel/git/konrad/xen.git devel/pvh.v12
> 
> implements the neccessary functionality to boot a PV guest in PVH mode.

In general this looks in much better shape now.  Some of the refactoring
patches should be queued for 3.14.

I'm not sure if when the rest wants to go in given that the PVH
hypervisor ABI is not yet finalized and is missing support for a number
of things with no visible plan for how/when/if this missing
functionality will be implemented.

David
