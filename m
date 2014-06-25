Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756882AbaFYMod (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 08:44:33 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:50484 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755990AbaFYMob (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 08:44:31 -0400
Date: Wed, 25 Jun 2014 13:42:12 +0100
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: Jiri Slaby <jslaby@suse.cz>
Cc: linux-kernel@vger.kernel.org, tj@kernel.org, rostedt@goodmis.org,
        mingo@redhat.com, akpm@linux-foundation.org, andi@firstfloor.org,
        paulmck@linux.vnet.ibm.com, pavel@ucw.cz, jirislaby@gmail.com,
        Vojtech Pavlik <vojtech@suse.cz>, Michael Matz <matz@suse.de>,
        Jiri Kosina <jkosina@suse.cz>, Udo Seidel <udoseidel@gmx.de>
Subject: Re: [PATCH -repost 05/21] kgr: update Kconfig documentation
Message-ID: <20140625134212.4fb38e14@alan.etchedpixels.co.uk>
In-Reply-To: <1403694435-3180-5-git-send-email-jslaby@suse.cz>
References: <1403694435-3180-1-git-send-email-jslaby@suse.cz>
	<1403694435-3180-5-git-send-email-jslaby@suse.cz>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.23; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 25 Jun 2014 13:06:59 +0200
Jiri Slaby <jslaby@suse.cz> wrote:

> This is based on Udo's text which was augmented in this patch.
> 
> Signed-off-by: Jiri Slaby <jslaby@suse.cz>
> Cc: Udo Seidel <udoseidel@gmx.de>
> Cc: Vojtech Pavlik <vojtech@suse.cz>
> ---
>  kernel/Kconfig.kgraft | 3 +++
>  samples/Kconfig       | 4 ++++
>  2 files changed, 7 insertions(+)
> 
> diff --git a/kernel/Kconfig.kgraft b/kernel/Kconfig.kgraft
> index f38d82c06580..bead93646071 100644
> --- a/kernel/Kconfig.kgraft
> +++ b/kernel/Kconfig.kgraft
> @@ -5,3 +5,6 @@ config KGRAFT
>  	bool "kGraft infrastructure"
>  	depends on DYNAMIC_FTRACE_WITH_REGS
>  	depends on HAVE_KGRAFT
> +	help
> +	  Select this to enable kGraft online kernel patching. The
> +	  runtime price is zero, so it is safe to say Y here.
> diff --git a/samples/Kconfig b/samples/Kconfi

The runtime impact is that you've just introduced a virus and trojan
writers delight into your kernel. There's a balance between convenience
and security but given most users will never use kgraft this advice seems
incorrect.

