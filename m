Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753013AbaKFQyj (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:54:39 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:53414 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751558AbaKFQvs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:51:48 -0500
Date: Thu, 6 Nov 2014 08:51:39 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Neela Syam Kolli <megaraidlinux@lsi.com>,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Alexander Gordeev <agordeev@redhat.com>, linux-pci@vger.kernel.org,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] megaraid_sas : Fix bug in handling return value of
 pci_enable_msix_range()
Message-ID: <20141106165139.GA17176@infradead.org>
References: <1415018660-30775-1-git-send-email-jiang.liu@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1415018660-30775-1-git-send-email-jiang.liu@linux.intel.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

applied to the drivers-for-3.18 branch.

