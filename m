Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752872AbaHXPhd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Aug 2014 11:37:33 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56291 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752610AbaHXPhc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Aug 2014 11:37:32 -0400
Date: Sun, 24 Aug 2014 08:37:25 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sreekanth Reddy <sreekanth.reddy@avagotech.com>
Cc: jejb@kernel.org, hch@infradead.org, martin.petersen@oracle.com,
        linux-scsi@vger.kernel.org, JBottomley@Parallels.com,
        Sathya.Prakash@avagotech.com, Nagalakshmi.Nandigama@avagotech.com,
        linux-kernel@vger.kernel.org, Robert Elliott <elliott@hp.com>
Subject: Re: [RESEND][PATCH 07/10] [SCSI] mpt2sas: Added Reply Descriptor
 Post Queue  (RDPQ) Array support
Message-ID: <20140824153725.GC16490@infradead.org>
References: <1408806260-14552-1-git-send-email-Sreekanth.Reddy@avagotech.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408806260-14552-1-git-send-email-Sreekanth.Reddy@avagotech.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Can you please send me a single big series with all the mpt2 and mpt3
updates?  With all the resends I'm losing track.

Please also pick up third party mpt patches like
'[PATCH 3/3] mpt3sas, mpt2sas: fix scsi_add_host error handling problems in _scsih_probe' from Robert Elliott.

And while I can't enforce it on you git send-email really is your
friend for that.

