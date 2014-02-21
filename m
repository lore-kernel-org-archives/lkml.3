Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933284AbaBURAw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 12:00:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:8049 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932849AbaBURAv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 12:00:51 -0500
Date: Fri, 21 Feb 2014 18:02:44 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Cc: linux-kernel@vger.kernel.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Vrabel <david.vrabel@citrix.com>, linux-pci@vger.kernel.org
Subject: Re: [PATCH v2] xen-pciback: Use pci_enable_msix_exact() instead of
 pci_enable_msix()
Message-ID: <20140221170243.GL17353@dhcp-26-207.brq.redhat.com>
References: <20140221165235.GF17353@dhcp-26-207.brq.redhat.com>
 <20140221165340.GG17353@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140221165340.GG17353@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Boris et al,

Based on recently accepted to the mainline pci_enable_msix_exact() function,
I am sending a updated version of the patch. Please, let me know if it does
not work for you and you need and incremental update from the previous version.

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
