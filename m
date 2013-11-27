Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755352Ab3K0LNn (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 06:13:43 -0500
Received: from bombadil.infradead.org ([198.137.202.9]:43710 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755224Ab3K0LNl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 06:13:41 -0500
Date: Wed, 27 Nov 2013 03:13:40 -0800
From: Christoph Hellwig <hch@infradead.org>
To: Aurelien Jarno <aurelien@aurel32.net>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        Christoph Hellwig <hch@infradead.org>, "Theodore Ts'o" <tytso@mit.edu>,
        linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] UAPI linux/fs.h: add a warning about wrong ioctl
 argument types
Message-ID: <20131127111340.GA24022@infradead.org>
References: <1385548839-16617-1-git-send-email-aurelien@aurel32.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385548839-16617-1-git-send-email-aurelien@aurel32.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SRS-Rewrite: SMTP reverse-path rewritten from <hch@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Aurelien,

the added comment looks good and very useful,

Reviewed-by: Christoph Hellwig <hch@lst.de>


We don't have any man pages documenting these ioctls or other user
visible documentation, do we?
