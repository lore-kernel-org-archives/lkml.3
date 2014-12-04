Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932459AbaLDO7c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 09:59:32 -0500
Received: from mout.kundenserver.de ([212.227.17.10]:51014 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932173AbaLDO7b convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 09:59:31 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: "Lad, Prabhakar" <prabhakar.csengg@gmail.com>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] misc: suppress build warning
Date: Thu, 04 Dec 2014 15:59:28 +0100
Message-ID: <12630889.EI0exeDoNc@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.16.0-10-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1417703910-2474-1-git-send-email-prabhakar.csengg@gmail.com>
References: <1417703910-2474-1-git-send-email-prabhakar.csengg@gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
X-Provags-ID: V03:K0:IzMPB1gkN35IV+f7zaUoWNsPwPeTFkwCkvgRDn4Q044vUYoSpnh
 5XC+n2tl6wkvahUvdyawecxT0NyHBaI8lGHz33errpSxUZSHJgXCnNI6N8dwUcdm3s5SYgs
 bKR23R3Yli7b7FKKzz33QNjw9bOYJPL9H6hF77bNgae063IbR8BnnAY779VmJS5fusJti4O
 TDHEjpcp7qst+RdGURT6g==
X-UI-Out-Filterresults: notjunk:1;
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 04 December 2014 14:38:30 Lad, Prabhakar wrote:
> this patch fixes following build warning:
> 
> drivers/misc/ioc4.c: In function ‘ioc4_probe’:
> drivers/misc/ioc4.c:194:16: warning: ‘start’ may be used uninitialized in this function [-Wmaybe-uninitialized]
>   period = (end - start) /
>                 ^
> drivers/misc/ioc4.c:148:11: note: ‘start’ was declared here
>   uint64_t start, end, period;
> 
> Signed-off-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>

Please explain why the compiler thinks there is a bug, why you 
are sure that there isn't, and why you picked '0' as the
initialization value.

	Arnd
