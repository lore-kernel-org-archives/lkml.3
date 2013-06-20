Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965717Ab3FTRIQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Jun 2013 13:08:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48491 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935373Ab3FTRIO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Jun 2013 13:08:14 -0400
Date: Thu, 20 Jun 2013 10:08:55 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Jiang Liu <liuj97@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Jeremy Fitzhardinge <jeremy@goop.org>,
        Jiang Liu <jiang.liu@huawei.com>, Yijing Wang <wangyijing@huawei.com>,
        xen-devel@lists.xensource.com,
        virtualization@lists.linux-foundation.org, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, Chris Metcalf <cmetcalf@tilera.com>,
        Thierry Reding <thierry.reding@avionic-design.de>
Subject: Re: [PATCH 3/3] PCI: mark pci_scan_bus_parented() as __deprecated
Message-ID: <20130620170855.GA21465@kroah.com>
References: <1371747665-12768-1-git-send-email-liuj97@gmail.com>
 <1371747665-12768-4-git-send-email-liuj97@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1371747665-12768-4-git-send-email-liuj97@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 21, 2013 at 01:01:05AM +0800, Jiang Liu wrote:
> From: Jiang Liu <jiang.liu@huawei.com>
> 
> Mark pci_scan_bus_parented() as __deprecated and clean up outdated
> comments.

Why not just delete the function, if no in-kernel users are calling it,
it's no longer needed at all.

thanks,

greg k-h
