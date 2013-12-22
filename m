Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755578Ab3LVTab (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Dec 2013 14:30:31 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:33931 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751232Ab3LVTaa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Dec 2013 14:30:30 -0500
Date: Sun, 22 Dec 2013 11:30:29 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] closures: move to lib/
Message-ID: <20131222193029.GA4848@infradead.org>
References: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
 <20131219120516.GA26089@infradead.org>
 <20131219121830.GA25385@kmo-pixel>
 <20131219121935.GA9561@infradead.org>
 <20131219122107.GB25385@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219122107.GB25385@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:21:07AM -0800, Kent Overstreet wrote:
> Grep through drivers/md/bcache/...

While that will require a fair amount of work I'm pretty sure we could
untangle that mess as well.  But what I meant was whatever piece of code
that motivated you to move the code to lib/.
