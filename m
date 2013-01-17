Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755308Ab3AQTUp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Jan 2013 14:20:45 -0500
Received: from plane.gmane.org ([80.91.229.3]:35246 "EHLO plane.gmane.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751814Ab3AQTUo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Jan 2013 14:20:44 -0500
X-Injected-Via-Gmane: http://gmane.org/
To: linux-kernel@vger.kernel.org
From: rh <richard_hubbe11@lavabit.com>
Subject: Re: [PATCH 76/86] fs/btrfs: remove depends on CONFIG_EXPERIMENTAL
Date: Thu, 17 Jan 2013 11:20:30 -0800
Message-ID: <20130117112030.6fa36b08cdf227c8c6e6f7b3@lavabit.com>
References: <1358391258-1771-1-git-send-email-keescook@chromium.org>
	<1358391258-1771-77-git-send-email-keescook@chromium.org>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-Complaints-To: usenet@ger.gmane.org
X-Gmane-NNTP-Posting-Host: ip68-227-87-145.sb.sd.cox.net
User-Agent: dsodnetnin
X-Mailer: EZnn0.37p
X-Newsreader: EZnn0.37p
X-Gmane-NNTP-Posting-Host: EZnn0.37p
Original-Received: from slem by 1.1 with local
X-No-Archive: yes
Archive: no
X-Archive: expiry=11
X-Archive: encrypt
X-Operating-System: Barebones_6.1
X-Gmane-NNTP-Posting-Host: 192.168.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 16 Jan 2013 18:54:08 -0800
Kees Cook <keescook@chromium.org> wrote:

> The CONFIG_EXPERIMENTAL config item has not carried much meaning for a
> while now and is almost always enabled by default. As agreed during
> the Linux kernel summit, remove it from any "depends on" lines in
> Kconfigs.
> 
> Cc: Chris Mason <chris.mason@fusionio.com>
> Cc: Al Viro <viro@zeniv.linux.org.uk>
> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> Signed-off-by: Kees Cook <keescook@chromium.org>
> ---
>  fs/btrfs/Kconfig |    3 +--
>  1 file changed, 1 insertion(+), 2 deletions(-)
> 
> diff --git a/fs/btrfs/Kconfig b/fs/btrfs/Kconfig
> index d33f01c..ccd25ba 100644
> --- a/fs/btrfs/Kconfig
> +++ b/fs/btrfs/Kconfig
> @@ -1,6 +1,5 @@
>  config BTRFS_FS
> -	tristate "Btrfs filesystem (EXPERIMENTAL) Unstable disk
> format"
> -	depends on EXPERIMENTAL
> +	tristate "Btrfs filesystem Unstable disk format"

No longer an experiment but still "Unstable".  But is it broken?
Or is it staging or a pet? 
>From my naive point of view it seems like this set of patches is
unleashing a bunch of bad stuff onto anyone that actually sets
CONFIG_EXPERIMENTAL "n". But I guess it's supposed to get caught in
linux-next.

>  	select LIBCRC32C
>  	select ZLIB_INFLATE
>  	select ZLIB_DEFLATE
> -- 
> 1.7.9.5
> 


-- 


