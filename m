Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758310AbaJ3I3X (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 04:29:23 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:52759 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750998AbaJ3I3V (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 04:29:21 -0400
Date: Thu, 30 Oct 2014 01:29:20 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Sudip Mukherjee <sudipm.mukherjee@gmail.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, Don Brace <don.brace@pmcs.com>,
        Robert Elliott <elliott@hp.com>
Subject: Re: [PATCH] MAINTAINERS: remove list iss_storagedev@hp.com
Message-ID: <20141030082920.GA24815@infradead.org>
References: <1414651659-4485-1-git-send-email-sudipm.mukherjee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1414651659-4485-1-git-send-email-sudipm.mukherjee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 12:17:39PM +0530, Sudip Mukherjee wrote:
> when sending mail to iss_storagedev@hp.com it failed permanently
> 
> "Google tried to deliver your message, but it was rejected by the
> server for the recipient domain hp.com by smtp.hp.com.
> [15.201.208.57].
> The error that the other server returned was:
> 550 5.1.1 <iss_storagedev@hp.com>: Recipient address
> rejected: User unknown in virtual alias table"

I've got a MAINTAINERS update for these drivers queued up, but it only
adds a new maintainer, and an additional list, but doesn't remove this
one.  Don, Robert - should we remove the list as well, or should it come
back?

