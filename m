Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932093AbaJNK5b (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Oct 2014 06:57:31 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:53956 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754823AbaJNK53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Oct 2014 06:57:29 -0400
Date: Tue, 14 Oct 2014 03:57:29 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Dmitry Monakhov <dmonakhov@openvz.org>
Cc: linux-kernel@vger.kernel.org, linux-ext4@vger.kernel.org
Subject: Re: [PATCH 4/4] ext4: Add fdatasync scalability optimization
Message-ID: <20141014105729.GA19981@infradead.org>
References: <1413281035-6483-1-git-send-email-dmonakhov@openvz.org>
 <1413281035-6483-5-git-send-email-dmonakhov@openvz.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413281035-6483-5-git-send-email-dmonakhov@openvz.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Much of the bookkeeping here seems generic and should be in common
code and not inside a filesystem.

