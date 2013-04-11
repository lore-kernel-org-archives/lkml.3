Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759883Ab3DKWhk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 18:37:40 -0400
Received: from mail-ie0-f171.google.com ([209.85.223.171]:40078 "EHLO
	mail-ie0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752591Ab3DKWhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 18:37:38 -0400
MIME-Version: 1.0
In-Reply-To: <CA+G9fYuq3eJp6pfSPXjdPqY7DAW6LF1Q5uDA02GOS65_voo6Bw@mail.gmail.com>
References: <CA+G9fYuq3eJp6pfSPXjdPqY7DAW6LF1Q5uDA02GOS65_voo6Bw@mail.gmail.com>
Date: Fri, 12 Apr 2013 00:37:38 +0200
Message-ID: <CACRpkdaKajsFc=WGg1OAvBajs5ziCeXbk=-cnMV6EmB3L8rxPg@mail.gmail.com>
Subject: Re: [Linaro-QA-Service] [linux-next] Snowball build broken
From: Linus Walleij <linus.walleij@linaro.org>
To: Naresh Kamboju <naresh.kamboju@linaro.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Lists linaro-dev <linaro-dev@lists.linaro.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 11, 2013 at 8:28 PM, Naresh Kamboju
<naresh.kamboju@linaro.org> wrote:

> One of those ARM targets is Snowball. Snowball build broken log can be found
> here
>
> Build Error:
>
> 04:48:08   CC      drivers/mfd/ab8500-debugfs.o
> 04:48:09
> /mnt/ci_build/workspace/linux-next/hwpack/snowball/label/precise_hwpack_cloud/drivers/mfd/ab8500-debugfs.c:95:23:
> fatal error: mach/irqs.h: No such file or directory
> 04:48:09 compilation terminated.
> 04:48:09 make[3]: *** [drivers/mfd/ab8500-debugfs.o] Error 1
> 04:48:09 make[2]: *** [drivers/mfd] Error 2
> 04:48:09 make[1]: *** [drivers] Error 2

Hey it works. Didn't see this before I fixed it tho :-)
http://marc.info/?l=linux-kernel&m=136567139910888&w=2

Yours,
Linus Walleij
