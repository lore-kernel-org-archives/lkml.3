Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759530AbaGPLln (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 07:41:43 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:34382 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758324AbaGPLlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 07:41:37 -0400
Date: Wed, 16 Jul 2014 04:41:36 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Al Viro <viro@zeniv.linux.org.uk>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: VFS tree for 3.17?
Message-ID: <20140716114136.GA25237@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Al,

Do you plan to put a VFS tree together for 3.17?  To me the various
renameat2 bits from Miklos are something I'd really prefer to not miss,
but there might be other bits waiting for attention as well.
