Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753055AbaKJOT0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 09:19:26 -0500
Received: from smtp1.it.da.ut.ee ([193.40.5.66]:58026 "EHLO smtp1.it.da.ut.ee"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752942AbaKJOTX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 09:19:23 -0500
Date: Mon, 10 Nov 2014 16:19:17 +0200 (EET)
From: Meelis Roos <mroos@linux.ee>
To: Christoph Hellwig <hch@infradead.org>
cc: Chad Dupuis <chad.dupuis@qlogic.com>,
        Joe Carnuccio <joe.carnuccio@qlogic.com>,
        Saurav Kashyap <saurav.kashyap@qlogic.com>,
        Christoph Hellwig <hch@lst.de>, qla2xxx-upstream@qlogic.com,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: bisected regression: qla2xxx endianness on sparc64
In-Reply-To: <20141110141555.GB12347@infradead.org>
Message-ID: <alpine.LRH.2.11.1411101617030.31442@siim2.ut.ee>
References: <alpine.DEB.2.03.1411022004230.3979@cyber.ee> <alpine.OSX.2.00.1411031508560.1960@administrators-macbook-pro.local> <alpine.LRH.2.11.1411032330370.19361@siim2.ut.ee> <20141110141555.GB12347@infradead.org>
User-Agent: Alpine 2.11 (LRH 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> On Mon, Nov 03, 2014 at 11:32:14PM +0200, Meelis Roos wrote:
> > Yes. I took the same 3.18.0-rc1-00422-g2cc9188-dirty kernel that had 
> > just this patch reverted, it started the controller fine, detected disk, 
> > mounted root, started multiple tasks and then some time after startin 
> > exim it just hangs. This is consisten with what I saw during bisection.
> 
> Can you try to bisect this one as well?

I have tried for many evenings but it is not so easy. With current 
bisecting, I have lost good base version, even going back to 3.17 and 
3.16 breaks for now. I will try more after some days when I have an idea 
what did I change to break it (some conf option perhaps).

-- 
Meelis Roos (mroos@linux.ee)
