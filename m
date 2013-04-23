Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756544Ab3DWPRB (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 11:17:01 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:56871 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755835Ab3DWPQ7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 11:16:59 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 00/10] usb: musb: ux500: pathe the way for Device Tree enablement
Date: Tue, 23 Apr 2013 17:16:54 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-18-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com, mian.yousaf.kaukab@stericsson.com
References: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1366729394-11406-1-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304231716.54516.arnd@arndb.de>
X-Provags-ID: V02:K0:8LkRICothbz9suttvgMs6cuvhICoErjHLBgpCmxapzp
 Kd5N3ZNR9N3qMgnBiJBn4SE5uR0kkM6Mb5sMfzfFxBb4tKusdM
 d+qU57MyNV+vK0b52RbtS234IMjBe7sC6znMLarKHaTJ4mLaz6
 BM9q0L6eAU3xd+ImtxP4dUnUOleyTCgi8HtMBwuApWKDzegJaV
 XZIOZsHP7iVJDqwlsg6zlbEDVNYbu+hd/MZueARd/j7BTxqnui
 xPMuKPtQH4GIKMtiQRY+yEfLkIdBjUFwI9xa+a10LMMO8fhRIp
 xEpM/TznYUdjomjXnmzrf7irVVbQOohrI6xCeKrGku+48zC/X8
 m1H7rS5F1kY8OnkXSazg=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 23 April 2013, Lee Jones wrote:
> In this patch-set we firstly ease the burden on data being passed from
> platform data, then start to build up support to finally enable Device
> Tree.

Very nice series!

I only have two small comments on the binding document, everything else looks
great.

Acked-by: Arnd Bergmann <arnd@arndb.de>
