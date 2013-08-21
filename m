Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3HUGas (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 02:30:48 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:42552 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752279Ab3HUGaq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 02:30:46 -0400
Date: Tue, 20 Aug 2013 23:30:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: "Nicholas A. Bellinger" <nab@daterainc.com>
Cc: target-devel <target-devel@vger.kernel.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-scsi <linux-scsi@vger.kernel.org>,
        Christoph Hellwig <hch@lst.de>, Hannes Reinecke <hare@suse.de>,
        Martin Petersen <martin.petersen@oracle.com>,
        Chris Mason <chris.mason@fusionio.com>,
        James Bottomley <JBottomley@Parallels.com>,
        Nicholas Bellinger <nab@linux-iscsi.org>
Subject: Re: [PATCH 1/9] scsi: Add CDB definition for COMPARE_AND_WRITE
Message-ID: <20130821063042.GF25506@infradead.org>
References: <1377029280-19144-1-git-send-email-nab@daterainc.com>
 <1377029280-19144-2-git-send-email-nab@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377029280-19144-2-git-send-email-nab@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
