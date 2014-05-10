Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbaEJRSt (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 13:18:49 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40235 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751971AbaEJRSr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 13:18:47 -0400
Date: Sat, 10 May 2014 19:18:45 +0200
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Arnd Bergmann <arnd@arndb.de>, akpm@linux-foundation.org,
        linux-kernel@vger.kernel.org, linux-api@vger.kernel.org
Subject: Re: [PATCH] drivers/char/mem.c: Add /dev/ioports, supporting 16-bit
 and 32-bit ports
Message-ID: <20140510171845.GA799@kroah.com>
References: <20140509191914.GA7286@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140509191914.GA7286@jtriplet-mobl1>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 09, 2014 at 12:19:16PM -0700, Josh Triplett wrote:
> @@ -827,6 +898,9 @@ static const struct memdev {
>  #ifdef CONFIG_PRINTK
>  	[11] = { "kmsg", 0644, &kmsg_fops, NULL },
>  #endif
> +#ifdef CONFIG_DEVPORT
> +	 [12] = { "ioports", 0, &ioports_fops, NULL },

Odd extra space?

