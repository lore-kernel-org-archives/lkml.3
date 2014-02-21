Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754623AbaBUXqS (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 18:46:18 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:37308 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753502AbaBUXqQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 18:46:16 -0500
Date: Fri, 21 Feb 2014 15:46:13 -0800
From: Jens Axboe <axboe@kernel.dk>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mike Miller <mike.miller@hp.com>,
        Asai Thambi S P <asamymuthupa@micron.com>,
        Joshua Morris <josh.h.morris@us.ibm.com>,
        Philip Kelleher <pjk1939@linux.vnet.ibm.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, iss_storagedev@hp.com,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH 0/9] block: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140221234613.GE29129@kernel.dk>
References: <cover.1392799751.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1392799751.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Feb 19 2014, Alexander Gordeev wrote:
> As result of deprecation of MSI-X/MSI enablement functions
> pci_enable_msix() and pci_enable_msi_block() all drivers
> using these two interfaces need to be updated to use the
> new pci_enable_msi_range() and pci_enable_msix_range()
> interfaces.

Thanks. Applied 3-4, and 6-9 (didn't get the others).

-- 
Jens Axboe

