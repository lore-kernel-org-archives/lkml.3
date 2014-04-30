Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759511AbaD3VRs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 17:17:48 -0400
Received: from mx1.redhat.com ([209.132.183.28]:21688 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753734AbaD3VRr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 17:17:47 -0400
Date: Wed, 30 Apr 2014 23:19:03 +0200
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-mips@linux-mips.org, linuxppc-dev@lists.ozlabs.org,
        linux-s390@vger.kernel.org, x86@kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 2/2] PCI/MSI: Phase out pci_enable_msi_block()
Message-ID: <20140430211902.GA5550@dhcp-26-207.brq.redhat.com>
References: <cover.1397458024.git.agordeev@redhat.com>
 <0b08613dc17cd608c1babc1f42b8919f60e1093f.1397458024.git.agordeev@redhat.com>
 <20140414120921.GA32132@dhcp-26-207.brq.redhat.com>
 <20140414132834.GA9164@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140414132834.GA9164@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 14, 2014 at 03:28:34PM +0200, Alexander Gordeev wrote:
> There are no users of pci_enable_msi_block() function have
> left. Obsolete it in favor of pci_enable_msi_range() and
> pci_enable_msi_exact() functions.

Hi Bjorn,

How about this one?

Thanks!

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
