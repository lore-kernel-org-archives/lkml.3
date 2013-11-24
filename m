Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756142Ab3KXJQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 24 Nov 2013 04:16:17 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:60206 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932073Ab3KXJQH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 24 Nov 2013 04:16:07 -0500
Date: Sun, 24 Nov 2013 01:16:02 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tejun Heo <tj@kernel.org>
Cc: gregkh@linuxfoundation.org, kay@vrfy.org, linux-kernel@vger.kernel.org,
        ebiederm@xmission.com, bhelgaas@google.com
Subject: Re: [PATCHSET driver-core-next] sysfs: separate out kernfs, take #3
Message-ID: <20131124091602.GA1454@infradead.org>
References: <1385245346-856-1-git-send-email-tj@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385245346-856-1-git-send-email-tj@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It would be highly useful if you could explain us what kernfs is
supposed to do and why we're cheerfully waiting for it.  Also given
that you touch VFS core files please Cc linux-fsdevel for those and
explain them in detail.

