Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751416Ab3HTNA7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 09:00:59 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:39538 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751049Ab3HTNA5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 09:00:57 -0400
Date: Tue, 20 Aug 2013 06:00:56 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dave Kleikamp <dave.kleikamp@oracle.com>
Cc: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        Andrew Morton <akpm@linux-foundation.org>,
        "Maxim V. Patlasov" <mpatlasov@parallels.com>,
        Zach Brown <zab@zabbo.net>
Subject: Re: [PATCH V8 00/33] loop: Issue O_DIRECT aio using bio_vec
Message-ID: <20130820130056.GA9652@infradead.org>
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

As I've seen very few replies to this:  how do we ensure this gets
picked up for the 3.12 merge window?  The series has been a reposted
a few times without complaints or major changes, but the ball still
doesn't seem to get rolling.

I'd really like to do some ecryptfs and scsi target work that is going
to rely on this soon.
