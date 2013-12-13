Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752555Ab3LMQhg (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 11:37:36 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:55851 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751872Ab3LMQhe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 11:37:34 -0500
Date: Fri, 13 Dec 2013 08:37:33 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Zhi Yong Wu <zwu.kernel@gmail.com>
Cc: xfs@oss.sgi.com, linux-fsdevel@vger.kernel.org,
        Zhi Yong Wu <wuzhy@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/5] xfs: add xfs_create_tmpfile() for O_TMPFILE support
Message-ID: <20131213163733.GF20803@infradead.org>
References: <1386944873-16796-1-git-send-email-zwu.kernel@gmail.com>
 <1386944873-16796-4-git-send-email-zwu.kernel@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1386944873-16796-4-git-send-email-zwu.kernel@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> +	error = xfs_dir_ialloc(&tp, NULL, mode, 0, rdev,

please pass the parent inode pointer here.

> +				XFS_PROJID_DEFAULT, resblks > 0,

and pass the project id that you inherited from the parent here.

