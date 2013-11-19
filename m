Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753458Ab3KSQcE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 11:32:04 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:42685 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465Ab3KSQcB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 11:32:01 -0500
Date: Tue, 19 Nov 2013 08:31:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: James Custer <jcuster@sgi.com>
Cc: linux-mm@kvack.org, Rik van Riel <riel@redhat.com>,
        Mel Gorman <mgorman@suse.de>,
        "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Jiang Liu <jiang.liu@huawei.com>,
        Michel Lespinasse <walken@google.com>, Hugh Dickins <hughd@google.com>,
        Oleg Nesterov <oleg@redhat.com>, Al Viro <viro@zeniv.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Reimplement old functionality of vm_munmap to
 vm_munmap_mm
Message-ID: <20131119163133.GA18355@infradead.org>
References: <1384878592-194909-1-git-send-email-jcuster@sgi.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384878592-194909-1-git-send-email-jcuster@sgi.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 10:29:52AM -0600, James Custer wrote:
> Commit bfce281c287a427d0841fadf5d59242757b4e620 killed the mm parameter to
> vm_munmap. Although the mm parameter was not used in any in-tree kernel
> modules, it is used by some out-of-tree modules.

Which doesn't matter at all.

