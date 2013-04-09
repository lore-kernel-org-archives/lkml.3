Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935576Ab3DIS4C (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Apr 2013 14:56:02 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:51027 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1761262Ab3DIS4A (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Apr 2013 14:56:00 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Lee Jones <lee.jones@linaro.org>
Subject: Re: [PATCH 7/8] dmaengine: ste_dma40: Use the BIT macro to replace ugly '(1 << x)'s
Date: Tue, 9 Apr 2013 20:55:55 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        linus.walleij@stericsson.com
References: <1365532783-27425-1-git-send-email-lee.jones@linaro.org> <1365532783-27425-7-git-send-email-lee.jones@linaro.org>
In-Reply-To: <1365532783-27425-7-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-15"
Content-Transfer-Encoding: 7bit
Message-Id: <201304092055.55661.arnd@arndb.de>
X-Provags-ID: V02:K0:zcw/gmOn8dykBcxwf10J+2v8hdd9US9GYOssVYX5/7t
 jKsfBUteCSIIbrzN5VnDKdgzjsWRd0+m0mc8ASD6bnbuhVQX3z
 qNjY/UGLNvo+AlFJOec8jkJvFS8IctpehS+Sb5caaYx9rbnysv
 qjrIAi3afhugK/Sjv0Amn2LKhy2/1SO6BS+rVdLulbojzm1022
 Jw3D1PrE2+CAbChiOBskfbIgG/50TscSoKgm7OhTFQbNeH5SRd
 FWBS734ncwRaH2Nz45F47Zw6sJKLYqylFJoJyKqVz7iopSKIiv
 jqFb1vbglCVEw1J/C4Tziowy+OxB+JG1WvBp5zoQzB0etRtbZw
 IpAnPrBxWI4Iwy9zVOzI=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 09 April 2013, Lee Jones wrote:
> The aim is to make the code that little more readable.
> 
> Signed-off-by: Lee Jones <lee.jones@linaro.org>

I don't find the new version any more or less readable than the old one,
but I have no objections if other people think it's a good idea.

Acked-by: Arnd Bergmann <arnd@arndb.de>
