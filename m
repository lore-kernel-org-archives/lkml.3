Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756516Ab3LSMF0 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:05:26 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49589 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756490Ab3LSMFR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:05:17 -0500
Date: Thu, 19 Dec 2013 04:05:16 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: linux-kernel@vger.kernel.org, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] closures: move to lib/
Message-ID: <20131219120516.GA26089@infradead.org>
References: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 05:29:54PM -0800, Kent Overstreet wrote:
> the closure code was never intended to be bcache specific - hopefully it can be
> useful elsewhere in the kernel.

They are not.  They aren't closures in the CS sense, and they are an
ugly mess.  Please work on removing them instead.
