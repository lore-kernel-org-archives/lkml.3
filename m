Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751974AbaDCLzd (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Apr 2014 07:55:33 -0400
Received: from smtp02.citrix.com ([66.165.176.63]:4624 "EHLO SMTP02.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbaDCLz2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Apr 2014 07:55:28 -0400
X-IronPort-AV: E=Sophos;i="4.97,786,1389744000"; 
   d="scan'208";a="116406741"
Message-ID: <533D4C2D.4000803@citrix.com>
Date: Thu, 3 Apr 2014 12:55:25 +0100
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Daeseok Youn <daeseok.youn@gmail.com>
CC: <konrad.wilk@oracle.com>, <boris.ostrovsky@oracle.com>, <joe@perches.com>,
        <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <JBeulich@suse.com>
Subject: Re: [PATCH v2] xen: fix memory leak in __xen_pcibk_add_pci_dev()
References: <2172979.BN2CJo57Rq@daeseok-laptop.cloud.net>
In-Reply-To: <2172979.BN2CJo57Rq@daeseok-laptop.cloud.net>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/04/14 11:15, Daeseok Youn wrote:
> 
> It need to free dev_entry when it failed to assign to a new
> slot on the virtual PCI bus.
> 
> smatch says:
>  drivers/xen/xen-pciback/vpci.c:142 __xen_pcibk_add_pci_dev() warn:
> possible memory leak of 'dev_entry'

Applied to devel/for-linus-3.15.

Thanks.

David
