Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752816AbaHXRbF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 13:31:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:33254 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752552AbaHXRbD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 13:31:03 -0400
Date: Sun, 24 Aug 2014 10:31:01 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Alexander Gordeev <agordeev@redhat.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Naresh Kumar Inna <naresh@chelsio.com>,
        Arvind Bhushan <arvindb@chelsio.com>,
        Jayamohan Kallickal <jayamohan.kallickal@emulex.com>,
        linux-scsi@vger.kernel.org, linux-pci@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>
Subject: Re: [PATCH v3 00/13] scsi: Use pci_enable_msix_range() instead of
 pci_enable_msix()
Message-ID: <20140824173101.GA24145@infradead.org>
References: <cover.1408335523.git.agordeev@redhat.com>
 <20140819170047.GA7237@infradead.org>
 <20140820191416.GA1886@agordeev.usersys.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140820191416.GA1886@agordeev.usersys.redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've applied all other patches except for the lpfc one now.

Thanks again!
