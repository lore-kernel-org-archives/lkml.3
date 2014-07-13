Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753552AbaGMLuc (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Jul 2014 07:50:32 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:36327 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751358AbaGMLuY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Jul 2014 07:50:24 -0400
Date: Sun, 13 Jul 2014 04:50:22 -0700
From: Christoph Hellwig <hch@infradead.org>
To: pramod.gurav.etc@gmail.com
Cc: viro@zeniv.linux.org.uk, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] fs/direct-io.c: Fix compilation warning for
 uninitialized variables
Message-ID: <20140713115022.GA6054@infradead.org>
References: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404452632-10912-1-git-send-email-pramod.gurav.etc@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Looks good to me,

Reviewed-by: Christoph Hellwig <hch@lst.de>

Al, can you pick this up?  It's the only warnings in many of my usual
kernel builds at the moment.

