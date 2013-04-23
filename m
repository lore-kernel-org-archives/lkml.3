Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757844Ab3DWWCV (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 18:02:21 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34442 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757745Ab3DWWCL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 18:02:11 -0400
Date: Tue, 23 Apr 2013 15:02:09 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Andi Kleen <andi@firstfloor.org>
Cc: hein_tibosch@yahoo.es, linux-kernel@vger.kernel.org,
        Andi Kleen <ak@linux.intel.com>
Subject: Re: [PATCH] fix initconst in lib/decompress.c
Message-Id: <20130423150209.24d179d9cc508024829aa250@linux-foundation.org>
In-Reply-To: <1366515885-18131-1-git-send-email-andi@firstfloor.org>
References: <1366515885-18131-1-git-send-email-andi@firstfloor.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 20 Apr 2013 20:44:45 -0700 Andi Kleen <andi@firstfloor.org> wrote:

> From: Andi Kleen <ak@linux.intel.com>
> 
> 
> diff --git a/lib/decompress.c b/lib/decompress.c
> index 31a8042..f8fdeda 100644
> --- a/lib/decompress.c
> +++ b/lib/decompress.c
> @@ -38,7 +38,7 @@ struct compress_format {
>  	decompress_fn decompressor;
>  };
>  
> -static const struct compress_format compressed_formats[] __initdata = {
> +static const struct compress_format compressed_formats[] __initconst = {
>  	{ {037, 0213}, "gzip", gunzip },
>  	{ {037, 0236}, "gzip", gunzip },
>  	{ {0x42, 0x5a}, "bzip2", bunzip2 },

That's missing both a changelog and the signed-off-by.  Did your
scripts break?

