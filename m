Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751871AbaLOI31 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 03:29:27 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:41928 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750970AbaLOI30 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 03:29:26 -0500
Date: Mon, 15 Dec 2014 00:29:07 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kevin Cernekee <cernekee@gmail.com>
Cc: tglx@linutronix.de, bp@alien8.de, gnomes@lxorguk.ukuu.org.uk,
        computersforpeace@gmail.com, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, corbet@lwn.net, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC 1/4] Documentation: Change policy on sending patches during
 merge window
Message-ID: <20141215082907.GA7730@infradead.org>
References: <1418623790-28429-1-git-send-email-cernekee@gmail.com>
 <1418623790-28429-2-git-send-email-cernekee@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1418623790-28429-2-git-send-email-cernekee@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Dec 14, 2014 at 10:09:47PM -0800, Kevin Cernekee wrote:
> Ask patch submitters to avoid sending non-critical patches when the
> merge window is open.  This basically extends the net-next policy in
> netdev-FAQ.txt to the entire kernel.

FYI, I very mich disagree with that.  Merge window isn't really special,
and patches can easily be reviewed and queued up for the next merge
window in that time.  If it said you shouldn't expect replies and not
_resend_ during the merge window that seems like a much saner policy.
