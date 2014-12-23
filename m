Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756672AbaLWXLR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Dec 2014 18:11:17 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48479 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751616AbaLWXLQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Dec 2014 18:11:16 -0500
Date: Wed, 24 Dec 2014 00:11:13 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Josh Poimboeuf <jpoimboe@redhat.com>
cc: Seth Jennings <sjenning@redhat.com>, Vojtech Pavlik <vojtech@suse.cz>,
        live-patching@vger.kernel.org, linux-kernel@vger.kernel.org,
        Udo Seidel <udoseidel@gmx.de>
Subject: Re: [PATCH] samples/livepatch: fix usage example comments
In-Reply-To: <51835fd54ceacfd68a0c044dd9b625506cc733b8.1419375802.git.jpoimboe@redhat.com>
Message-ID: <alpine.LNX.2.00.1412240010460.1680@pobox.suse.cz>
References: <51835fd54ceacfd68a0c044dd9b625506cc733b8.1419375802.git.jpoimboe@redhat.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 23 Dec 2014, Josh Poimboeuf wrote:

> Fix a few typos in the livepatch-sample.c usage example comments and add
> some whitespace to make the comments a little more legible.
> 
> Reported-by: Udo Seidel <udoseidel@gmx.de>
> Signed-off-by: Josh Poimboeuf <jpoimboe@redhat.com>

[ adding Udo to CC ]

Applied, thanks.

> ---
>  samples/livepatch/livepatch-sample.c | 6 +++++-
>  1 file changed, 5 insertions(+), 1 deletion(-)
> 
> diff --git a/samples/livepatch/livepatch-sample.c b/samples/livepatch/livepatch-sample.c
> index 21f159d..fb8c861 100644
> --- a/samples/livepatch/livepatch-sample.c
> +++ b/samples/livepatch/livepatch-sample.c
> @@ -26,12 +26,16 @@
>   * kernel boot cmdline when /proc/cmdline is read.
>   *
>   * Example:
> + *
>   * $ cat /proc/cmdline
>   * <your cmdline>
> + *
>   * $ insmod livepatch-sample.ko
>   * $ cat /proc/cmdline
>   * this has been live patched
> - * $ echo 0 > /sys/kernel/livepatch/klp_sample/enabled
> + *
> + * $ echo 0 > /sys/kernel/livepatch/livepatch_sample/enabled
> + * $ cat /proc/cmdline
>   * <your cmdline>
>   */
>  
> -- 
> 2.1.0
> 

-- 
Jiri Kosina
SUSE Labs
