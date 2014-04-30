Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965156AbaD3Q0A (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 12:26:00 -0400
Received: from smtp.citrix.com ([66.165.176.89]:59252 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759193AbaD3QZ6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 12:25:58 -0400
X-IronPort-AV: E=Sophos;i="4.97,959,1389744000"; 
   d="scan'208";a="126386683"
Message-ID: <53612413.7000801@citrix.com>
Date: Wed, 30 Apr 2014 17:25:55 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <jbeulich@suse.com>
Subject: Re: [PATCH v1] Documentation and two bug-fixes for Xen pciback.
References: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1398866051-32714-1-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 30/04/14 14:54, Konrad Rzeszutek Wilk wrote:
> Hey,
> 
> This patchset is just a simple documentation and two bug-fixes
> to the Xen pciback. I am still looking at implementing the proper
> way of doing reset for the devices - based on David's feedback - but
> that is going to take a big of time. In the meantime this patchset
> is presented as today is the documentation day!
> 
> 
>  drivers/xen/xen-pciback/pci_stub.c | 25 +++++++++++++++++++------
>  drivers/xen/xen-pciback/xenbus.c   |  4 ++++
>  2 files changed, 23 insertions(+), 6 deletions(-)
> 
> Konrad Rzeszutek Wilk (6):
>       xen-pciback: Cleanup up pcistub_put_pci_dev
>       xen-pciback: First reset, then free.
>       xen-pciback: Document when we FLR an PCI device.
>       xen/pciback: Document when the 'unbind' and 'bind' functions are called.
>       xen/pciback: Document the entry points for 'pcistub_put_pci_dev'

These:

Reviewed-by: David Vrabel <david.vrabel@citrix.com>

>       xen/pciback: Don't call xen_pcibk_config_init_dev when device
de-assigned.

Could you just check that nothing relied on the dyn_fields() being
deleted here.

David
