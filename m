Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751293AbaLEOY3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 09:24:29 -0500
Received: from ou.quest-ce.net ([195.154.187.82]:59651 "EHLO ou.quest-ce.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750896AbaLEOY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 09:24:27 -0500
Message-ID: <1417789428.11111.31.camel@opteya.com>
From: Yann Droneaud <ydroneaud@opteya.com>
To: Masahiro Yamada <yamada.m@jp.panasonic.com>
Cc: linux-kbuild@vger.kernel.org, Michal Marek <mmarek@suse.cz>,
        Jonathan Corbet <corbet@lwn.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org, Sam Ravnborg <sam@ravnborg.org>,
        Yann Droneaud <ydroneaud@opteya.com>
Date: Fri, 05 Dec 2014 15:23:48 +0100
In-Reply-To: <1417494533-24461-1-git-send-email-yamada.m@jp.panasonic.com>
References: <1417494533-24461-1-git-send-email-yamada.m@jp.panasonic.com>
Organization: OPTEYA
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.12.8 (3.12.8-1.fc21) 
Mime-Version: 1.0
Content-Transfer-Encoding: 8bit
X-SA-Exim-Connect-IP: 37.162.178.179
X-SA-Exim-Mail-From: ydroneaud@opteya.com
Subject: Re: [PATCH] kbuild: remove old information in headers_install.txt
 document
X-SA-Exim-Version: 4.2.1 (built Mon, 26 Dec 2011 16:24:06 +0000)
X-SA-Exim-Scanned: Yes (on ou.quest-ce.net)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Le mardi 02 décembre 2014 à 13:28 +0900, Masahiro Yamada a écrit :
> The arch header directories "include/asm-*" were moved long before.
> 
> Signed-off-by: Masahiro Yamada <yamada.m@jp.panasonic.com>
> ---
> 
>  Documentation/kbuild/headers_install.txt | 5 +----
>  1 file changed, 1 insertion(+), 4 deletions(-)
> 
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
>  INSTALL_HDR_PATH indicates where to install the headers.  It defaults to
>  "./usr/include".

Back in september, I've already sent a patch[1] to address this,
following a discussion with Sam Ravnborg[2]. See the mail thread[3].

Regards.

[1] http://lkml.kernel.org/r/b5181cf7604baa454c11f7aa92d07dd05349ce46.1410712841.git.ydroneaud@opteya.com
[2] http://lkml.kernel.org/r/20140713212608.GB16496@ravnborg.org
[3] http://lkml.kernel.org/g/cover.1410712841.git.ydroneaud@opteya.com

-- 
Yann Droneaud
OPTEYA



