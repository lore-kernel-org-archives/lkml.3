Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758162Ab3K0XCm (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 18:02:42 -0500
Received: from hall.aurel32.net ([195.154.112.97]:58454 "EHLO hall.aurel32.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757971Ab3K0XCk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 18:02:40 -0500
Date: Thu, 28 Nov 2013 00:02:07 +0100
From: Aurelien Jarno <aurelien@aurel32.net>
To: Christoph Hellwig <hch@infradead.org>
Cc: linux-kernel@vger.kernel.org, Alexander Viro <viro@zeniv.linux.org.uk>,
        "Theodore Ts'o" <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
Subject: Re: [PATCH] UAPI linux/fs.h: add a warning about wrong ioctl
 argument types
Message-ID: <20131127230207.GF29912@hall.aurel32.net>
Mail-Followup-To: Aurelien Jarno <aurelien@aurel32.net>,
	Christoph Hellwig <hch@infradead.org>, linux-kernel@vger.kernel.org,
	Alexander Viro <viro@zeniv.linux.org.uk>,
	Theodore Ts'o <tytso@mit.edu>, linux-fsdevel@vger.kernel.org
References: <1385548839-16617-1-git-send-email-aurelien@aurel32.net>
 <20131127111340.GA24022@infradead.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20131127111340.GA24022@infradead.org>
X-Mailer: Mutt 1.5.21 (2010-09-15)
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 03:13:40AM -0800, Christoph Hellwig wrote:
> Thanks Aurelien,
> 
> the added comment looks good and very useful,
> 
> Reviewed-by: Christoph Hellwig <hch@lst.de>
> 

Thanks for the review.

> We don't have any man pages documenting these ioctls or other user
> visible documentation, do we?

The only documentation I have found about these ioctls is from the
ioctl_list(2) manpage, but with different name and defined in
<linux/ext2_fs.h>. In any case they are correctly defined:

       0x80046601   EXT2_IOC_GETFLAGS     int *
       0x40046602   EXT2_IOC_SETFLAGS     const int *
       0x80047601   EXT2_IOC_GETVERSION   int *
       0x40047602   EXT2_IOC_SETVERSION   const int *

-- 
Aurelien Jarno	                        GPG: 1024D/F1BCDB73
aurelien@aurel32.net                 http://www.aurel32.net
