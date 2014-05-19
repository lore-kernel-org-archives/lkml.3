Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932768AbaESRSo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 13:18:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:60066 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932375AbaESRSn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 13:18:43 -0400
Date: Mon, 19 May 2014 10:18:39 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Chen Gang <gang.chen.5i5j@gmail.com>
Cc: JBottomley@parallels.com, Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Guan Xuetao <gxt@mprc.pku.edu.cn>, linux-scsi@vger.kernel.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] [PATCH] drivers: scsi: mvsas: fix compiling issue by
 adding 'MVS_' for "enum pci_interrupt_cause"
Message-ID: <20140519171839.GB32250@infradead.org>
References: <536C2D2B.6090501@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <536C2D2B.6090501@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>
