Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753509AbaG2Miz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:38:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34473 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751044AbaG2Miy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 08:38:54 -0400
Date: Tue, 29 Jul 2014 05:38:53 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, iss_storagedev@hp.com,
        intel-linux-scu@intel.com, support@lsi.com, DL-MPTFusionLinux@lsi.com,
        qla2xxx-upstream@qlogic.com, iscsi-driver@qlogic.com,
        pv-drivers@vmware.com, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v2 RESEND 00/23] scsi: Use pci_enable_msix_range()
 instead of pci_enable_msix()
Message-ID: <20140729123853.GA23629@infradead.org>
References: <cover.1405533479.git.agordeev@redhat.com>
 <20140717202820.GA16924@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140717202820.GA16924@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jul 17, 2014 at 01:28:20PM -0700, Christoph Hellwig wrote:
> Can I get reviews for the patches still missing one, maybe from the
> Distro folks?  I'd like to pull in the whole things in favor of cherry
> picking the reviewed patches.

I've applied those few patches that did get a review to the
drivers-for-3.17 branch.   It still would be great if someone could help
reviewing the others.
