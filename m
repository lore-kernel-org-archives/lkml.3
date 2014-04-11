Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756209AbaDKImc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 04:42:32 -0400
Received: from moutng.kundenserver.de ([212.227.17.24]:64345 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755705AbaDKIm3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 04:42:29 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Chanwoo Choi <cw00.choi@samsung.com>, Olof Johansson <olof@lixom.net>,
        linux-samsung-soc@vger.kernel.org, t.figa@samsung.com,
        hyunhee.kim@samsung.com, sw0312.kim@samsung.com,
        linux-kernel@vger.kernel.org, yj44.cho@samsung.com,
        inki.dae@samsung.com, kyungmin.park@samsung.com, kgene.kim@samsung.com
Subject: Re: [PATCH 03/27] ARM: EXYNOS: Add IO mapping for PMU of Exynos3250
Date: Fri, 11 Apr 2014 10:41:54 +0200
Message-ID: <5435579.0l6Y80MnUs@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <53474D66.7020605@samsung.com>
References: <1397122658-16013-1-git-send-email-cw00.choi@samsung.com> <20140411014858.GC14934@quad.lixom.net> <53474D66.7020605@samsung.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:un493LhOK7GB2tSFD3Pj0m8sr4n1rxwY+9qNncnpRvn
 Jf0wnSnOqryV4j+Pt9PdSQhyd4ekrb/WgNi/6a5ZXBXrDkauMC
 K5nwpOAzmSIN3AG7ZBZ3PcMYuXFNS4i5QOkUUbQtgxC/lLVeLi
 rKAYKsa5wyZCdpVgeL6HuM7mK4Qi6x6UQnHK2sP5W2XZUlya44
 EQZ/vUZfcwRMvbvr51OQWUrtSs3B4FHSwWTnWtchGkBNFkJu/1
 OpdcZfS4mLflnE/ROeI7cq6JtrGOkiZ+jB5zZtT8XGcWKHHS3i
 hSV5u74Xfqd6F7buc9PgCOGNXhsLKgcMIW4JXyh7DxnzktrfFI
 izujUNio1PK1WryTqA28=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday 11 April 2014 11:03:18 Chanwoo Choi wrote:
> On 04/11/2014 10:48 AM, Olof Johansson wrote:
> > On Thu, Apr 10, 2014 at 06:37:14PM +0900, Chanwoo Choi wrote:
> >> This patch add memory mapping for PMU (Power Management Unit) which is used
> >> for power control of Exynos3250.
> >>
> >> Signed-off-by: Chanwoo Choi <cw00.choi@samsung.com>
> >> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> > 
> > Signed-off-by is in the wrong order, if Kyungmin wrote the patch and you're
> > just posting it...
> 
> 
> No, I implemented this patch and posted it.

What did Kyungmin do then? If you submitted the patch to him, and he
sent it back to you, you should be listed twice, although you could
just as easily leave him out.

	Arnd
