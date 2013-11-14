Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757010Ab3KNUpq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 15:45:46 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:51860 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755078Ab3KNUph (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 15:45:37 -0500
Date: Thu, 14 Nov 2013 12:45:36 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org,
        Christoph Hellwig <hch@lst.de>
Subject: Re: [PATCH] MAINTAINERS: Add an entry for the Macintosh HFSPlus
 Filesystem
Message-Id: <20131114124536.c3b886ae13fb3f5d1757cc4e@linux-foundation.org>
In-Reply-To: <1384461563-4487-1-git-send-email-geert@linux-m68k.org>
References: <1384461563-4487-1-git-send-email-geert@linux-m68k.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 14 Nov 2013 21:39:23 +0100 Geert Uytterhoeven <geert@linux-m68k.org> wrote:

> To make scripts/get_maintainer.pl output something sensible.
> 
> Signed-off-by: Geert Uytterhoeven <geert@linux-m68k.org>
> ---
> I guess it's orphaned, just like HFS?
> 
>  MAINTAINERS |    6 ++++++
>  1 file changed, 6 insertions(+)
> 
> diff --git a/MAINTAINERS b/MAINTAINERS
> index f23575ed1416..f1a0e7464ce0 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -3921,6 +3921,12 @@ S:	Orphan
>  F:	Documentation/filesystems/hfs.txt
>  F:	fs/hfs/
>  
> +HFSPLUS FILESYSTEM
> +L:	linux-fsdevel@vger.kernel.org
> +S:	Orphan
> +F:	Documentation/filesystems/hfsplus.txt
> +F:	fs/hfsplus/
> +
>  HGA FRAMEBUFFER DRIVER
>  M:	Ferenc Bakonyi <fero@drama.obuda.kando.hu>
>  L:	linux-nvidia@lists.surfsouth.com

Actually I think Christoph keeps an eye on hfsplus?
