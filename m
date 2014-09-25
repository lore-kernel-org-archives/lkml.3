Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754111AbaIYPwz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 11:52:55 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:41971 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753804AbaIYPwx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 11:52:53 -0400
Date: Thu, 25 Sep 2014 08:52:52 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Alexander Viro <viro@zeniv.linux.org.uk>
Cc: linux-kernel@vger.kernel.org
Subject: enable sparse endianess checking by default?
Message-ID: <20140925155252.GA5720@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's been quite a while that we had sparse support in the build system,
and we still disable the checks for endianess annotations by default.

For many subsystems these are arguably the most useful ones, and with
Fengguang's build bot running sparse checks we're also being harder
on driver maintainers to sort these out even where they don't matter
too much for them (e.g. PCI hardware that mostly runs on x86).

Is there any reason to still keep the opt-in for these when running
sparse?

Now running sparse by default if available would be another useful
project, but I'll save that for a later time..
