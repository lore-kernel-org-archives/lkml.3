Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752381AbbAJKPJ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Jan 2015 05:15:09 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:34690 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750780AbbAJKPH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Jan 2015 05:15:07 -0500
Date: Sat, 10 Jan 2015 02:14:54 -0800
From: Christoph Hellwig <hch@infradead.org>
To: "Martin K. Petersen" <martin.petersen@oracle.com>
Cc: Sreekanth Reddy <sreekanth.reddy@avagotech.com>, jejb@kernel.org,
        hch@infradead.org, linux-scsi@vger.kernel.org,
        JBottomley@Parallels.com, Sathya.Prakash@avagotech.com,
        Nagalakshmi.Nandigama@avagotech.com, linux-kernel@vger.kernel.org,
        Elliott@hp.com
Subject: Re: [PATCH 09/22] [SCSI] mpt2sas, mpt3sas: Added a support to set
 cpu affinity for each MSIX vector enabled by the HBA
Message-ID: <20150110101454.GA4919@infradead.org>
References: <1420635329-2268-1-git-send-email-Sreekanth.Reddy@avagotech.com>
 <yq1twzzzn6f.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1twzzzn6f.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 09, 2015 at 03:58:16PM -0500, Martin K. Petersen wrote:
> (Still dreaming of a combined mpt2sas and mpt3sas so I wouldn't have to
> review everything twice).

We really need to start that action instead of dreaming.  Once this
series is in I'll move the two drivers to at least a shared set of
mpt firmware headers as a start, and then we'll need to find ways to
work from that piecemail.

Note that the mpt headers also would be useful for the megaraid_sas
driver which has it's own hand crafted version, but that's another
story..
