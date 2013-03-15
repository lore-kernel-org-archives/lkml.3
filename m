Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754152Ab3COLaC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Mar 2013 07:30:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.186]:56790 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752077Ab3COLaA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Mar 2013 07:30:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
Subject: Re: [Suggestion] Latest randconfig build errors for Head.S
Date: Fri, 15 Mar 2013 11:29:43 +0000
User-Agent: KMail/1.12.2 (Linux/3.8.0-8-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org,
        Andrea Adami <andrea.adami@gmail.com>,
        Chen Gang <gang.chen@asianux.com>, matthew.leach@arm.com,
        dave.martin@linaro.org,
        "Russell King - ARM Linux" <linux@arm.linux.org.uk>, nico@linaro.org,
        Will Deacon <will.deacon@arm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        matthew.gretton-dann@linaro.org
References: <51415428.1070401@asianux.com> <201303151056.55819.arnd@arndb.de> <514301E8.9040201@gmail.com>
In-Reply-To: <514301E8.9040201@gmail.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="gb2312"
Content-Transfer-Encoding: 7bit
Message-Id: <201303151129.43542.arnd@arndb.de>
X-Provags-ID: V02:K0:e6heCheXdX9q9ykhgyeEF3won2C89b5dhiX/vL+cc+Y
 65Q+j+MqOCzhInv9BamTRP0ZUueZ1H6hXZbB1ZCBSOjesB1VSx
 Lb9eQAOzn2TkoFoLk+d2C2hI7EtDLMoIaOum4cx95D0rZtjGtX
 +EamK2alKOw6k8yNxgqjd3JCH1arTL25q0Sxqr+lHtzPngwdHj
 b71hb9m9L3c5nYsvIaFJETO9UKMiu9erx12YO38N7hUF0pqcuZ
 WDHPOgLkFK/09ysBbGm6S4fhWEbhE+U0DtitsXu9ryZvfMChFX
 dYDBwX5Jh5CryTKPIIzuGPx2ob0CKxN3ZunI3/X36orwOUV71D
 MRK7zrXnVpesSnXNNSDA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 15 March 2013, Chen Gang F T wrote:
>   excuse me, my English is not quite well.
> 
>   I guess your meaning is:
>     "that bug" means the toolchain's bug (need toolchain people fix it).
>     prefer to apply your patch, before "that bug" is fixed (we don't know when)
> 
>   is it correct ?

Yes, correct.

	Arnd
