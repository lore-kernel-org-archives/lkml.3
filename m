Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751930AbaLONng (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 08:43:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:49632 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750862AbaLONnc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 08:43:32 -0500
Date: Mon, 15 Dec 2014 05:43:31 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Tony Battersby <tonyb@cybernetics.com>
Cc: linux-scsi@vger.kernel.org,
        "James E.J. Bottomley" <JBottomley@parallels.com>,
        Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] scsi: fix random memory corruption with scsi-mq + T10 PI
Message-ID: <20141215134331.GA30961@infradead.org>
References: <54862444.3020901@cybernetics.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54862444.3020901@cybernetics.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks,

applied to drivers-for-3.19.
