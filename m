Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757852Ab3ILISH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 04:18:07 -0400
Received: from mail-ob0-f178.google.com ([209.85.214.178]:38586 "EHLO
	mail-ob0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757796Ab3ILISD convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 04:18:03 -0400
Date: Thu, 12 Sep 2013 03:18:00 -0500
From: Rob Landley <rob@landley.net>
Subject: Re: [PATCH] README: Alternative configuration commands does not
 mention make listnewconfig
To: Regid Ichira <regid23@nt1.in>
Cc: "Steven Mr. Procrastinator Rostedt" <rostedt@goodmis.org>,
        Jiri Kosina <jkosina@suse.cz>, linux-kernel@vger.kernel.org
References: <20130912003919.GG8821@nt1.in>
In-Reply-To: <20130912003919.GG8821@nt1.in> (from regid23@nt1.in on Wed Sep
	11 19:39:19 2013)
X-Mailer: Balsa 2.4.11
Message-Id: <1378973880.1974.11@driftwood>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii; DelSp=Yes; Format=Flowed
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/11/2013 07:39:19 PM, Regid Ichira wrote:
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
>       "make localyesconfig" Similar to localmodconfig, except it will  
> convert
>                             all module options to built in (=y)  
> options.
> 
> +     "make listnewconfig"  Based on the contents of your existing  
> ./.config
> +                        file, print all the new config symbols.  One  
> at a
> +                        line.
> +
>     You can find more information on using the Linux kernel config  
> tools
>     in Documentation/kbuild/kconfig.txt.

"make help" does, though. Possibly the README should point people at  
that instead of trying to keep a (third?) copy of this info in sync?

Rob