Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751677AbaKQPsU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Nov 2014 10:48:20 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:46198 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751031AbaKQPsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Nov 2014 10:48:18 -0500
Date: Mon, 17 Nov 2014 07:48:17 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Omar Sandoval <osandov@osandov.com>
Cc: linux-btrfs@vger.kernel.org, Mel Gorman <mgorman@suse.de>,
        linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org
Subject: Re: [RFC PATCH 0/6] btrfs: implement swap file support
Message-ID: <20141117154817.GA25670@infradead.org>
References: <cover.1416219974.git.osandov@osandov.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1416219974.git.osandov@osandov.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With the new iov_iter infrastructure that supprots direct I/O to kernel
pages please get rid of the ->readpage hack first.  I'm still utterly
disapoined that this crap ever got merged.

