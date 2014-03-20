Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755427AbaCTIOG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Mar 2014 04:14:06 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:35022 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755258AbaCTIOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Mar 2014 04:14:01 -0400
Date: Thu, 20 Mar 2014 01:13:59 -0700
From: Christoph Hellwig <hch@infradead.org>
To: Eric Biggers <ebiggers3@gmail.com>
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] vfs: Deduplicate code shared by xattr system calls
 operating on paths
Message-ID: <20140320081359.GB21164@infradead.org>
References: <1395285997-5106-1-git-send-email-ebiggers3@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1395285997-5106-1-git-send-email-ebiggers3@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good,

Reviewed-by: Christoph Hellwig <hch@lst.de>
