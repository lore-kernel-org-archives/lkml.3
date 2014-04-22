Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933151AbaDVPT7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:19:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:51844 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933116AbaDVPTp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:19:45 -0400
Date: Tue, 22 Apr 2014 08:19:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Drew Richardson <drew.richardson@arm.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Jerome Marchand <jmarchan@redhat.com>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>,
        Michel Lespinasse <walken@google.com>,
        Mikulas Patocka <mpatocka@redhat.com>,
        William Roberts <bill.c.roberts@gmail.com>,
        Gideon Israel Dsouza <gidisrael@gmail.com>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pawel Moll <pawel.moll@arm.com>
Subject: Re: [PATCH] Export kmem tracepoints for use by kernel modules
Message-ID: <20140422151939.GA19369@infradead.org>
References: <20140422142244.GA21121@dreric01-Precision-T1600>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140422142244.GA21121@dreric01-Precision-T1600>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 22, 2014 at 07:22:45AM -0700, Drew Richardson wrote:
> After commit de7b2973903c6cc50b31ee5682a69b2219b9919d ("tracepoint:
> Use struct pointer instead of name hash for reg/unreg tracepoints"),
> any tracepoints used in a kernel module must be exported.

But none of them are used by any in-tree module, so this isn't relevant.

