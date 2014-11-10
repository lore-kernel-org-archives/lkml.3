Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753111AbaKJOP2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:15:28 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42607 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752014AbaKJOP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:15:27 -0500
Date: Mon, 10 Nov 2014 06:15:19 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Chad Dupuis <chad.dupuis@qlogic.com>
Cc: Meelis Roos <mroos@linux.ee>, Joe Carnuccio <joe.carnuccio@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Christoph Hellwig <hch@lst.de>, qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bisected regression: qla2xxx endianness on sparc64
Message-ID: <20141110141519.GA12347@infradead.org>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee>
 <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 03:09:47PM -0500, Chad Dupuis wrote:
> We should revert that change. What were some of the other failures you were
> seeing?

Can you please send me the revert ASAP?

