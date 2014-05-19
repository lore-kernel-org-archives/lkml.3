Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805AbaESNpO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 09:45:14 -0400
Received: from tex.lwn.net ([70.33.254.29]:55522 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751331AbaESNpL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 09:45:11 -0400
Date: Mon, 19 May 2014 07:45:10 -0600
From: Jake Edge <jake@lwn.net>
To: Anton Saraev <antonysaraev@gmail.com>
Cc: gregkh@linuxfoundation.org, jason@lakedaemon.net,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 06/06] staging: crypto: skein: rename files
Message-ID: <20140519074510.74e622fd@chukar.edge2.net>
In-Reply-To: <a5204985750d7adf9b20752f889fbf2a2147de94.1399675445.git.antonysaraev@gmail.com>
References: <cover.1399675444.git.antonysaraev@gmail.com>
	<abebc2187151826190d6f664acc654241b352ffa.1399675444.git.antonysaraev@gmail.com>
	<dad2a43d54d03ba2b4fae9136331df060c48154c.1399675444.git.antonysaraev@gmail.com>
	<cba3f6453b416ea04b03ad2d165f600e3e39f152.1399675444.git.antonysaraev@gmail.com>
	<b4028782c333773298763d58e14753067c6ae745.1399675444.git.antonysaraev@gmail.com>
	<2eac124c6a3815c72e91679c8cde729af712bb74.1399675445.git.antonysaraev@gmail.com>
	<a5204985750d7adf9b20752f889fbf2a2147de94.1399675445.git.antonysaraev@gmail.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 19 May 2014 12:09:59 +0400 Anton Saraev wrote:

> --- a/drivers/staging/skein/Makefile
> +++ b/drivers/staging/skein/Makefile
> @@ -4,10 +4,10 @@
>  subdir-ccflags-y := -I$(src)/include/

as part of the rearranging of files, I think you want to get rid of
this include directory, move the files up to the main directory and
include them as "skein.h" (rather than <skein.h>).

Then this line can be removed from the Makefile.

> --- a/drivers/staging/skein/threefish1024Block.c
> +++ b/drivers/staging/skein/threefish_1024_block.c
> @@ -1,5 +1,5 @@
>  #include <linux/string.h>
> -#include <threefishApi.h>
> +#include <threefish_api.h>

incidentally, none of the threefish_*_block.c files actually needs
linux/string.h ... there may be other files where that's true too, it
seems to have just gotten added everywhere ...

jake

-- 
Jake Edge - LWN - jake@lwn.net - http://lwn.net
