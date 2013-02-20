Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758945Ab3BTKGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 05:06:49 -0500
Received: from moutng.kundenserver.de ([212.227.126.186]:61163 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753645Ab3BTKGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 05:06:45 -0500
From: Arnd Bergmann <arnd@arndb.de>
To: Alexander Shiyan <shc_work@mail.ru>
Subject: Re: Re[8]: [PATCH v3] mfd: syscon: Add non-DT support
Date: Wed, 20 Feb 2013 10:06:41 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-6-generic; KDE/4.3.2; x86_64; ; )
Cc: Dong Aisheng <dong.aisheng@linaro.org>, linux-kernel@vger.kernel.org,
        Samuel Ortiz <sameo@linux.intel.com>,
        Mark Brown <broonie@opensource.wolfsonmicro.com>
References: <1361198522-23789-1-git-send-email-shc_work@mail.ru> <1361271268.592027245@f310.mail.ru> <1361338882.986089809@f173.mail.ru>
In-Reply-To: <1361338882.986089809@f173.mail.ru>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302201006.41287.arnd@arndb.de>
X-Provags-ID: V02:K0:qyTy2g4PGWkHplLUuqrdBnf53VCxMKfgzzfiet/Tt+1
 izRVam58L8Aiqvknfqm1wWAyiWr6kBYbi5+Mdd1zYjysNgswd4
 lwo+Xc8FH/Ih6dDEgDo/JmHBnNNa9MUc+FTPE3X8rp2rtWAD5N
 Npz5rv5yBlJTaPK0gt0pXsyFidg9CYjPwXkO5PNdNYNEsdRZ9/
 94GjRFOs411BOwdDO4K4HTPQ+fSMV2qa9UJIEW4n/s5ih/bY36
 TGjwKOFqhNJ0GXRxeF7/0kD2nG8jQfFdLsA1EXYrr7i2Zcp1bm
 kCNsZQjMTZTCRO8gv6yWPo3+Xl/bQ8EhM+DGRc0qiNy++Llpx4
 3zqi9i1PvA1bEYZJX+qI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 20 February 2013, Alexander Shiyan wrote:
> On 20 February 2013 13:41, Alexander Shiyan <shc_work@mail.ru> wrote:
> > 
> > One problem is that every user needs to add their syscon compatible device
> > support(platform_device_id) in syscon driver first before they can use it.
> > But it looks to me just like how other driver generally does.
> 
> I agree, this is a more proper way, but in this case we should create a big table
> here with records for each device...
> 
> > Arnd,
> > Do you think this is an issue?

I would first like to get an answer to the question I asked in my first mail,
which is what the use case of non-DT support in this driver is. If this
is used only by a new platform that has to use DT anyway, or by an existing
platform that is easy enough to convert, we probably shouldn't do all this
at all.

	Arnd
