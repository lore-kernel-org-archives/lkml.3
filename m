Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753641Ab3IQROR (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 13:14:17 -0400
Received: from mail.kapsi.fi ([217.30.184.167]:40272 "EHLO mail.kapsi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752884Ab3IQROQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 13:14:16 -0400
Message-ID: <52388DB9.9020406@iki.fi>
Date: Tue, 17 Sep 2013 20:13:29 +0300
From: Antti Palosaari <crope@iki.fi>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jim Davis <jim.epost@gmail.com>
CC: Stephen Rothwell <sfr@canb.auug.org.au>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: Re: randconfig build error with next-20130917, in drivers/staging/media/msi3101
References: <CA+r1Zhig6Xc_-jw=nGqd18j0MfTbpLRZoVYYtFZ2wY5LUp6J5w@mail.gmail.com>
In-Reply-To: <CA+r1Zhig6Xc_-jw=nGqd18j0MfTbpLRZoVYYtFZ2wY5LUp6J5w@mail.gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
X-SA-Exim-Connect-IP: 82.128.186.45
X-SA-Exim-Mail-From: crope@iki.fi
X-SA-Exim-Scanned: No (on mail.kapsi.fi); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Jim,

That is maybe 5th times I got that same bug report :-] It is already 
fixed. Mauro tends to handle pending patches once per release candidate, 
so I think fix will be in next very soon (during this week).

https://patchwork.kernel.org/patch/2856771/
https://lkml.org/lkml/2013/9/12/824

regards
Antti


On 09/17/2013 08:05 PM, Jim Davis wrote:
> Building with the attached random configuration file,
>
>    LD      init/built-in.o
> drivers/built-in.o: In function `msi3101_probe':
> /home/jim/linux-randbuild/2/drivers/staging/media/msi3101/sdr-msi3101.c:1847:
> undefined reference to `vb2_vmalloc_memops'
> make: *** [vmlinux] Error 1
>


-- 
http://palosaari.fi/
