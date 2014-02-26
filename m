Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753830AbaBZT3u (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Feb 2014 14:29:50 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55224 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751495AbaBZT3s (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Feb 2014 14:29:48 -0500
Date: Wed, 26 Feb 2014 11:29:45 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Jens Axboe <axboe@kernel.dk>, Sam Bradshaw <sbradshaw@micron.com>,
        Asai Thambi S P <asamymuthupa@micron.com>
Cc: linux-kernel@vger.kernel.org
Subject: mtip32xx blk-mq status?
Message-ID: <20140226192945.GA26603@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

with blk-mq stabilizing in mainline and Jens using mtip32xx as tje major
example drivers in the past is there any progress on getting the
conversion finished and merged?
