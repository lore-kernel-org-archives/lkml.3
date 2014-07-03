Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756055AbaGCIem (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Jul 2014 04:34:42 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60644 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751382AbaGCIek (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Jul 2014 04:34:40 -0400
Date: Thu, 3 Jul 2014 01:34:37 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Emil Goode <emilgoode@gmail.com>
Cc: "James E.J. Bottomley" <JBottomley@parallels.com>,
        qla2xxx-upstream@qlogic.com, linux-scsi@vger.kernel.org,
        linux-kernel@vger.kernel.org, kernel-janitors@vger.kernel.org
Subject: Re: [PATCH] [SCSI] qla2xxx: Remove duplicate __iomem annotation
Message-ID: <20140703083437.GA30655@infradead.org>
References: <1404253914-24400-1-git-send-email-emilgoode@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404253914-24400-1-git-send-email-emilgoode@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
