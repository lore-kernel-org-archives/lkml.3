Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753964AbaHSRAx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 13:00:53 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52829 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148AbaHSRAu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 13:00:50 -0400
Date: Tue, 19 Aug 2014 10:00:47 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: linux-kernel@vger.kernel.org,
        Anil Ravindranath <anil_ravindranath@pmc-sierra.com>,
        James Smart <james.smart@emulex.com>,
        Naresh Kumar Inna <naresh@chelsio.com>,
        Arvind Bhushan <arvindb@chelsio.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        Chad Dupuis <chad.dupuis@qlogic.com>, Tomas Henzl <thenzl@redhat.com>,
        Nagalakshmi Nandigama <Nagalakshmi.Nandigama@lsi.com>,
        Sreekanth Reddy <Sreekanth.Reddy@lsi.com>,
        Kashyap Desai <Kashyap.desai@avagotech.com>,
        Neela Syam Kolli <megaraidlinux@lsi.com>,
        "Stephen M. Cameron" <scameron@beardog.cce.hp.com>,
        iss_storagedev@hp.com, support@lsi.com, DL-MPTFusionLinux@lsi.com,
        qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-pci@vger.kernel.org
Subject: Re: [PATCH v3 00/13] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140819170047.GA7237@infradead.org>
References: <cover.1408335523.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1408335523.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

I've applied patches 1 to 7 to the drivers-for-3.18 branch.

