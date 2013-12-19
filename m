Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756724Ab3LSMTi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:19:38 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49639 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753529Ab3LSMTg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 07:19:36 -0500
Date: Thu, 19 Dec 2013 04:19:35 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
        Tejun Heo <tj@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Oleg Nesterov <oleg@redhat.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Dan Williams <dan.j.williams@intel.com>
Subject: Re: [PATCH] closures: move to lib/
Message-ID: <20131219121935.GA9561@infradead.org>
References: <1387416594-23930-1-git-send-email-kmo@daterainc.com>
 <20131219120516.GA26089@infradead.org>
 <20131219121830.GA25385@kmo-pixel>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219121830.GA25385@kmo-pixel>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 19, 2013 at 04:18:30AM -0800, Kent Overstreet wrote:
> That's not really the kind of technical objection one can respond to. If
> you think there's a better way of doing this kind of asynchronous stuff,
> or a better mechanism already in the kernel (ha!) - please, by all
> means, enlighten us.

Show the actual use, and it shouldn't be hard to find something better.
