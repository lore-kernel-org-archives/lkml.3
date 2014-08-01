Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755036AbaHAMUn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 1 Aug 2014 08:20:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40085 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750876AbaHAMUm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 1 Aug 2014 08:20:42 -0400
Date: Fri, 1 Aug 2014 05:20:42 -0700
From: Christoph Hellwig <hch@infradead.org>
To: James Bottomley <James.Bottomley@HansenPartnership.com>
Cc: linux-scsi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [ANNOUNCE] scsi patch queue tree updated
Message-ID: <20140801122042.GA10771@infradead.org>
References: <20140708134003.GA7790@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140708134003.GA7790@infradead.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I've pushed out updates to both the core-for-3.17 and drivers-for-3.17
branches.  I think we're in a good shape for the merge window, but
I'd still like to get reviewers attention for a few driver updates that
I'd love to get in still:

 - my eata patch to remove the driver_lock
 - the partially reviewed megaraid series
 - the arcmsr series

