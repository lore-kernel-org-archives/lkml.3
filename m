Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754501AbaLDNoK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 08:44:10 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:27588 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754193AbaLDNoI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 08:44:08 -0500
X-IronPort-AV: E=Sophos;i="5.07,515,1413244800"; 
   d="scan'208";a="200070709"
Message-ID: <54806526.7040906@citrix.com>
Date: Thu, 4 Dec 2014 13:44:06 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.2.0
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>, <konrad.wilk@oracle.com>,
        <stefano.stabellini@eu.citrix.com>
CC: <linux-kernel@vger.kernel.org>, <jun.nakajima@intel.com>,
        <xen-devel@lists.xen.org>
Subject: Re: [Xen-devel] [PATCH v4 0/2] xen/pci: Use APIC for MSIs when APIC
 virtualization is supported
References: <1417551553-22234-1-git-send-email-boris.ostrovsky@oracle.com> <54803DF7.1030903@citrix.com>
In-Reply-To: <54803DF7.1030903@citrix.com>
Content-Type: text/plain; charset="windows-1252"
Content-Transfer-Encoding: 7bit
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/12/14 10:56, David Vrabel wrote:
> On 02/12/14 20:19, Boris Ostrovsky wrote:
>> Changes in v4:
>> * Added comment describing what we check for in pci_xen_init()
> 
> I applied v3 ages ago to the devel/for-linus-3.19 branch and I'm not
> going to mess about replacing it for a comment change.

I had to mess with it anyway to fix a build problem.  I've applied this
version.

Thanks.

David
