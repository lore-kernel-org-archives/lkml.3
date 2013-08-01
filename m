Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753020Ab3HAI6g (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 Aug 2013 04:58:36 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:43517 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751479Ab3HAI6e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 Aug 2013 04:58:34 -0400
Date: Thu, 1 Aug 2013 01:58:31 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20130801085831.GA21552@infradead.org>
References: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1374774659-13121-1-git-send-email-dave.kleikamp@oracle.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

What should be added to this support is to move the swap over nfs code
over to this interface instead of the utterly bogus
KERNEL_READ/KERNEL_WRITE hacks that were added for it.

