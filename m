Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754717AbaIVSCY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Sep 2014 14:02:24 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:48356 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753592AbaIVSCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Sep 2014 14:02:23 -0400
Date: Mon, 22 Sep 2014 11:02:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chris J Arges <chris.j.arges@canonical.com>
Cc: linux-scsi@vget.kernel.org, bruce.lucas@mongodb.com,
        Nagalakshmi Nandigama <nagalakshmi.nandigama@avagotech.com>,
        Praveen Krishnamoorthy <praveen.krishnamoorthy@avagotech.com>,
        Sreekanth Reddy <sreekanth.reddy@avagotech.com>,
        Abhijit Mahajan <abhijit.mahajan@avagotech.com>,
        MPT-FusionLinux.pdl@avagotech.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mptfusion: enable no_write_same in scsi_host_template
Message-ID: <20140922180220.GA10166@infradead.org>
References: <1411408690-4766-1-git-send-email-chris.j.arges@canonical.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1411408690-4766-1-git-send-email-chris.j.arges@canonical.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 22, 2014 at 12:56:59PM -0500, Chris J Arges wrote:
> When using a virtual SCSI disk in a VMWare VM if blkdev_issue_zeroout is used
> data can be improperly zeroed out using the mptfusion driver. This patch
> disables write_same for this driver which ensures that manual zeroing out
> is used instead.

Does this affet real hardware or is it a VMware bug?  If it's just the
latter we should simply blacklist VMware.

