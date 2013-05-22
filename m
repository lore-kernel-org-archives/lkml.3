Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757303Ab3EVUsf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 16:48:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41719 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756898Ab3EVUsd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 16:48:33 -0400
Date: Wed, 22 May 2013 13:48:32 -0700
From: Andrew Morton <akpm@linux-foundation.org>
To: Joern Engel <joern@logfs.org>
Cc: linux-kernel@vger.kernel.org, Jens Axboe <axboe@kernel.dk>,
        Borislav Petkov <bp@alien8.de>, Takashi Iwai <tiwai@suse.de>
Subject: Re: [PATCH 07/14] bcon: check for hdparm in bcon_tail
Message-Id: <20130522134832.5741eb0bcb0cdb30263021c6@linux-foundation.org>
In-Reply-To: <1368132193-25817-10-git-send-email-joern@logfs.org>
References: <1368132193-25817-1-git-send-email-joern@logfs.org>
	<1368132193-25817-10-git-send-email-joern@logfs.org>
X-Mailer: Sylpheed 3.2.0beta5 (GTK+ 2.24.10; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu,  9 May 2013 16:43:05 -0400 Joern Engel <joern@logfs.org> wrote:

> ...
>
> --- a/Documentation/block/blockconsole/bcon_tail
> +++ b/Documentation/block/blockconsole/bcon_tail
> @@ -14,6 +14,11 @@ if [ -z "$(which lsscsi)" ]; then
>  	exit 1
>  fi
>  
> +if [ -z "$(which hdparm)" ]; then
> +	echo "You need to install the hdparm package on your distro."
> +	exit 1
> +fi
> +
>  end_of_log() {
>  	DEV=$1
>  	UUID=`head -c40 $DEV|tail -c8`

Fold this one as well?
