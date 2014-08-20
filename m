Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751618AbaHTTHF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 15:07:05 -0400
Received: from mx1.redhat.com ([209.132.183.28]:38217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751625AbaHTTHD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 15:07:03 -0400
Date: Wed, 20 Aug 2014 20:14:17 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Naresh Kumar Inna <naresh@chelsio.com>,
        Arvind Bhushan <arvindb@chelsio.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH v3 00/13] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140820191416.GA1886@agordeev.usersys.redhat.com>
References: <cover.1408335523.git.agordeev@redhat.com>
 <20140819170047.GA7237@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140819170047.GA7237@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 19, 2014 at 10:00:47AM -0700, Christoph Hellwig wrote:
> Thanks,
> 
> I've applied patches 1 to 7 to the drivers-for-3.18 branch.

Thanks, Christoph!

Not sure how to handle the rest, though. Chelsio driver has no
maintainers and none of be2iscsi, pmcraid and csiostor has been
reviewed for several months.

-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
