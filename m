Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756547AbaAGBh2 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 Jan 2014 20:37:28 -0500
Received: from aserp1040.oracle.com ([141.146.126.69]:46250 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754806AbaAGBh1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 Jan 2014 20:37:27 -0500
Date: Mon, 6 Jan 2014 17:36:46 -0800
From: "Darrick J. Wong" <darrick.wong@oracle.com>
To: "Martin K. Petersen" <martin.petersen@oracle.com>, chuck.lever@oracle.com
Cc: Hannes Reinecke <hare@suse.de>, Christoph Hellwig <hch@infradead.org>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        linux-scsi@vger.kernel.org
Subject: Re: status of block-integrity
Message-ID: <20140107013646.GB10297@birch.djwong.org>
References: <20131222192128.GA28532@infradead.org>
 <52C6D0DB.1050906@suse.de>
 <yq1wqigzvc1.fsf@sermon.lab.mkp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <yq1wqigzvc1.fsf@sermon.lab.mkp.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: ucsinet21.oracle.com [156.151.31.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 03, 2014 at 03:03:42PM -0500, Martin K. Petersen wrote:
> >>>>> "Hannes" == Hannes Reinecke <hare@suse.de> writes:
> 
> Hannes> Personally, I doubt it's a good idea to kill it off, but a
> Hannes> proper (userland) API for it has been a long time missing.
> 
> Before we throw the baby out with the bath water, maybe Darrick can fill
> us in on the progress of the aio passthrough interface?

I haven't made much progress on it -- I haven't seen any earnest demand for it.

Last year Chuck Lever said that some NFS working group was looking defining an
interface it... has there been any progress?  It doesn't sound like there has
been.

--D
> 
> -- 
> Martin K. Petersen	Oracle Linux Engineering
