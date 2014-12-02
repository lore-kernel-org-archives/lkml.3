Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079AbaLBNjb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 08:39:31 -0500
Received: from tex.lwn.net ([70.33.254.29]:59767 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752709AbaLBNj2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 08:39:28 -0500
Date: Tue, 2 Dec 2014 08:39:26 -0500
From: Jonathan Corbet <corbet@lwn.net>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] kbuild: remove old information in headers_install.txt
 document
Message-ID: <20141202083926.084767fd@lwn.net>
In-Reply-To: <1417494533-24461-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1417494533-24461-1-git-send-email-yamada.m@jp.panasonic.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.11.1 (GTK+ 2.24.24; x86_64-redhat-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue,  2 Dec 2014 13:28:53 +0900
Masahiro Yamada <yamada.m@jp.panasonic.com> wrote:

> diff --git a/Documentation/kbuild/headers_install.txt b/Documentation/kbuild/headers_install.txt
> index 951eb9f..0d8fe5e 100644
> --- a/Documentation/kbuild/headers_install.txt
> +++ b/Documentation/kbuild/headers_install.txt
> @@ -28,10 +28,7 @@ optional arguments:
>  
>  ARCH indicates which architecture to produce headers for, and defaults to the
>  current architecture.  The linux/asm directory of the exported kernel headers
> -is platform-specific, to see a complete list of supported architectures use
> -the command:
> -
> -  ls -d include/asm-* | sed 's/.*-//'
> +is platform-specific.
>  

This change makes sense as far as it goes, but might it not be better to
tell readers the way to get the list of supported architectures in the
new scheme of things...?

Thanks,

jon
