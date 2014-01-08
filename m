Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932489AbaAHOEA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 09:04:00 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:64123 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932240AbaAHOD6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 09:03:58 -0500
Date: Wed, 8 Jan 2014 09:03:52 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: Kusanagi Kouichi <slash@ac.auone-net.jp>
Cc: linux-trace-users@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] trace-cmd: Fix out-of-tree build
Message-ID: <20140108090352.2a186287@gandalf.local.home>
In-Reply-To: <52cd4c9a000b471b000025a100006084180007d8d2e1@amlmta302.auone-net.jp>
References: <52cd4c9a000b471b000025a100006084180007d8d2e1@amlmta302.auone-net.jp>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 8 Jan 2014 22:03:22 +0900
Kusanagi Kouichi <slash@ac.auone-net.jp> wrote:

> make O=foo fails with following error:
> 
> .../Makefile:221: features.mk: No such file or directory
> make[1]: *** No rule to make target `features.mk'.  Stop.
> make: *** [sub-make] Error 2
> 
> Signed-off-by: Kusanagi Kouichi <slash@ac.auone-net.jp>

Thanks! Applied and pushed.

-- Steve

> ---
>  Makefile | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/Makefile b/Makefile
> index 0578546..b967019 100644
> --- a/Makefile
> +++ b/Makefile
> @@ -218,7 +218,7 @@ KERNELSHARK_VERSION = $(KS_VERSION).$(KS_PATCHLEVEL).$(KS_EXTRAVERSION)
>  
>  INCLUDES = -I. $(CONFIG_INCLUDES)
>  
> -include features.mk
> +include $(src)/features.mk
>  
>  # Set compile option CFLAGS if not set elsewhere
>  CFLAGS ?= -g -Wall

