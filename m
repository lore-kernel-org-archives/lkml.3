Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934659AbaJ3P1m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 11:27:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:50015 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934118AbaJ3P1j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 11:27:39 -0400
Date: Thu, 30 Oct 2014 08:27:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Don Brace <brace77070@gmail.com>
Cc: Fabian Frederick <fabf@skynet.be>, linux-kernel@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        iss_storagedev@hp.com, linux-scsi@vger.kernel.org, don.brace@pmcs.com,
        hch@infradead.org
Subject: Re: [PATCH 1/1 linux-next] hpsa: remove set but unused variable rc
Message-ID: <20141030152737.GA2818@infradead.org>
References: <1414595704-3119-1-git-send-email-fabf@skynet.be>
 <54525761.8070800@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54525761.8070800@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 30, 2014 at 10:21:05AM -0500, Don Brace wrote:
> I can add this patch to my current set of patches for 3.19 or ack this now,
> What would you prefer?

Please queue it up, I'm much more interested in reducing the massive
backlog of real hpsa changes than in litte cleanups at the moment.
