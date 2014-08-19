Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752713AbaHSPCb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 11:02:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:44858 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751808AbaHSPCa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 11:02:30 -0400
Date: Tue, 19 Aug 2014 08:02:21 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Ching Huang <ching2048@areca.com.tw>
Cc: hch@infradead.org, jbottomley@parallels.com, dan.carpenter@oracle.com,
        thenzl@redhat.com, agordeev@redhat.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v3 0/17] arcmsr: change note since v13 or v2
Message-ID: <20140819150221.GA4083@infradead.org>
References: <1408422598.4801.112.camel@Centos6.3-64>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408422598.4801.112.camel@Centos6.3-64>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Ching,

I've fixed up various checkpatch errors and fixed up some descriptions
and applied the patches to a branch.  This includes patch 4, so please
send a fix for this and any other patches relative to the branch.

Please find the branch at

	git://git.infradead.org/users/hch/scsi-queue.git arcmsr-for-3.18

Can the others help reviewing these patches and make sure we can get
them into 3.18?

Thanks,
	Christoph
