Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3JHMwi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Oct 2013 08:52:38 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40859 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3JHMwf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Oct 2013 08:52:35 -0400
Date: Tue, 8 Oct 2013 05:52:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Christian Ruppert <christian.ruppert@abilis.com>
Cc: Alexander Viro <viro@zeniv.linux.org.uk>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Export symbols for splice in modules
Message-ID: <20131008125229.GA8647@infradead.org>
References: <1381235898-24186-1-git-send-email-christian.ruppert@abilis.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1381235898-24186-1-git-send-email-christian.ruppert@abilis.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 08, 2013 at 02:38:18PM +0200, Christian Ruppert wrote:
> The symbols splice_to_pipe, splice_grow_spd and splice_shrink_spd are not
> currently exported from the kernel. This prevents the implementation of
> drivers using splice in modules not statically linked with the kernel. This
> patch exports those symbols to make it possible to implement splice in
> kernel modules.

Please submit these together with your drivers.  In general it seems
a higher level interface should be exported anyway.

