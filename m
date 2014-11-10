Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753211AbaKJOQA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:16:00 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43303 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753149AbaKJOP6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:15:58 -0500
Date: Mon, 10 Nov 2014 06:15:55 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Meelis Roos <mroos@linux.ee>
Cc: Chad Dupuis <chad.dupuis@qlogic.com>,
        Joe Carnuccio <joe.carnuccio@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Christoph Hellwig <hch@lst.de>, qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bisected regression: qla2xxx endianness on sparc64
Message-ID: <20141110141555.GB12347@infradead.org>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee>
 <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local>
 <alpine.LRH.2.11.1411032330370.19361@siim2.ut.ee>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.LRH.2.11.1411032330370.19361@siim2.ut.ee>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 11:32:14PM +0200, Meelis Roos wrote:
> Yes. I took the same 3.18.0-rc1-00422-g2cc9188-dirty kernel that had 
> just this patch reverted, it started the controller fine, detected disk, 
> mounted root, started multiple tasks and then some time after startin 
> exim it just hangs. This is consisten with what I saw during bisection.

Can you try to bisect this one as well?

