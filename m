Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3IKJdx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 05:33:53 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:27668 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751817Ab3IKJdw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 05:33:52 -0400
X-IronPort-AV: E=Sophos;i="4.90,883,1371081600"; 
   d="scan'208";a="50377707"
Message-ID: <523038FD.4070100@citrix.com>
Date: Wed, 11 Sep 2013 10:33:49 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <xen-devel@lists.xen.org>, <linux-kernel@vger.kernel.org>,
        <david.vrabel@citrix.com>, <JBeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v1 0/5] xen/PMU: PMU support for Xen PV guests
References: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
In-Reply-To: <1378827110-4192-1-git-send-email-boris.ostrovsky@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/09/13 16:31, Boris Ostrovsky wrote:
> This is the Linux side of Xen PMU support for PV guests, including dom0. Only
> kernel changes are here, toolstack patch will be provided separately.
> 
> Here is description from the hypervisor patch submission that applies to this
> series as well:
> 
> This version has following limitations:
> * For accurate profiling of dom0/Xen dom0 VCPUs should be pinned.
> * Hypervisor code is only profiled on processors that have running dom0 VCPUs
> on them.
> * No backtrace support.

These are some pretty significant limitations.   Is there a plan for how
to remove them?

David
