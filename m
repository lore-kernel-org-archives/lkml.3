Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752821Ab3LMQcg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:32:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55826 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752706Ab3LMQce (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:32:34 -0500
Date: Fri, 13 Dec 2013 08:32:30 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] xfs: adjust the interface of xfs_qm_vop_dqalloc()
Message-ID: <20131213163230.GE20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
 <1386944873-16796-3-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386944873-16796-3-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 10:27:50PM +0800, Zhi Yong Wu wrote:
> From: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>
> 
> There may be not a parent inode or a name for O_TMPFILE support, but will pass
> a struct xfs_mount to xfs_qm_vop_dqalloc(). So its interface need to be
> adjusted in order that O_TMPFILE creation function can also use it.
> 
> Signed-off-by: Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>

This patch is not actually needed, as we do get passed a parent.

