Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751537AbaANIwp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 03:52:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12306 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750949AbaANIwl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 03:52:41 -0500
Date: Tue, 14 Jan 2014 09:54:41 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Bjorn Helgaas <bhelgaas@google.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        linux-ide@vger.kernel.org, linux-pci@vger.kernel.org
Subject: Re: [PATCH 3/7] ahci: Use new interfaces for MSI/MSI-X enablement
Message-ID: <20140114085441.GB6873@dhcp-26-207.brq.redhat.com>
References: <cover.1389103215.git.agordeev@redhat.com>
 <7fe2a5563efac19c87213a48b58cae6b4d76c91d.1389103215.git.agordeev@redhat.com>
 <20140113191220.GA6525@google.com>
 <20140114085040.GA6873@dhcp-26-207.brq.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140114085040.GA6873@dhcp-26-207.brq.redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 14, 2014 at 09:50:40AM +0100, Alexander Gordeev wrote:
> What if we try to address both goals by making pci_enable_msi() a helper over
> pci_enable_msi_range(pdev, 1, 1)?

Or pci_enable_msi_single() to help reading and avoid drivers conversion mess.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
