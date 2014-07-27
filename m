Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752154AbaG0NTz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 27 Jul 2014 09:19:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:56514 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751290AbaG0NTx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 27 Jul 2014 09:19:53 -0400
Date: Sun, 27 Jul 2014 06:19:49 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Christoph Hellwig <hch@lst.de>, trond.myklebust@primarydata.com,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-nfs@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [BUG] nfs3_list_one_acl oops
Message-ID: <20140727131949.GB32153@infradead.org>
References: <20140726162143.GB20396@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140726162143.GB20396@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Russell, the patch looks good.

Andrew sent the same patch just a little earlier as well.

