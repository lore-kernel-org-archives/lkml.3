Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751466Ab3ILBGw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Sep 2013 21:06:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:33057 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750728Ab3ILBGv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Sep 2013 21:06:51 -0400
Message-ID: <523113A0.7090708@infradead.org>
Date: Wed, 11 Sep 2013 18:06:40 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130801 Thunderbird/17.0.8
MIME-Version: 1.0
To: Regid Ichira <regid23@nt1.in>
CC: "Steven \"Mr. Procrastinator\" Rostedt" <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] README: Alternative configuration commands does not mention
 make listnewconfig
References: <20130912003919.GG8821@nt1.in>
In-Reply-To: <20130912003919.GG8821@nt1.in>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/13 17:39, Regid Ichira wrote:
> Applied to the tip of linux.git,
>                       VERSION = 3 PATCHLEVEL = 11 SUBLEVEL = 0
> Signed-off-by: Regid Ichira <regid23@nt1.in>
> ---
>  README | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/README b/README
> index a24ec89..f10c16f 100644
> --- a/README
> +++ b/README
> @@ -228,6 +228,10 @@ CONFIGURING the kernel:
>       "make localyesconfig" Similar to localmodconfig, except it will convert
>                             all module options to built in (=y) options.
>  
> +     "make listnewconfig"  Based on the contents of your existing ./.config
> +                        file, print all the new config symbols.  One at a
                                                                 , one per line.

Wow, that's going to be a ton of symbols to read.

And about ./.config, does using O=<build-directory> apply to this (these)
commands?


> +                        line.
> +
>     You can find more information on using the Linux kernel config tools
>     in Documentation/kbuild/kconfig.txt.
>  
> 


-- 
~Randy
