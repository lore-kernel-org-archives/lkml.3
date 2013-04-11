Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754517Ab3DKKwK (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 06:52:10 -0400
Received: from moutng.kundenserver.de ([212.227.17.10]:56523 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750731Ab3DKKwI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 06:52:08 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Sylwester Nawrocki <s.nawrocki@samsung.com>
Subject: Re: [PATCH 11/30] [media] exynos: remove unnecessary header inclusions
Date: Thu, 11 Apr 2013 12:52:03 +0200
User-Agent: KMail/1.12.2 (Linux/3.8.0-16-generic; KDE/4.3.2; x86_64; ; )
Cc: Mauro Carvalho Chehab <mchehab@redhat.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Kukjin Kim <kgene.kim@samsung.com>, linux-samsung-soc@vger.kernel.org,
        linux-media@vger.kernel.org
References: <1365638712-1028578-1-git-send-email-arnd@arndb.de> <20130410211354.397d5689@redhat.com> <51667D3D.20103@samsung.com>
In-Reply-To: <51667D3D.20103@samsung.com>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="iso-8859-1"
Content-Transfer-Encoding: 7bit
Message-Id: <201304111252.04023.arnd@arndb.de>
X-Provags-ID: V02:K0:QO9EvomBRRCnUlVQiR0uG4RKBmNwd+kAaOb8TZV6uB2
 mEsKAM6BVQOa+121nG3eE/t/8mnT6XVsIsjAFgclIF/AQrKp1H
 R7dx9MQNIXga77wsqMNpBwwSI/23T4XbvlgpiAy6L/Vq5lgSrd
 VxoCGtMGl5mFU1XoSDCmyPE9N1ibuknse7b13exQHpsEg26aHD
 Rki466AIOT6/G6xNNT2Kn5YpiW+IDkhKMXX/f/yPUutdcpBnX3
 4G8r4CfbQisTpL8eQsYnVkp6IVxzpvXZ8Vo3tegXCQ5Vn6gb+2
 OuG5QAKqUxt3cITwiA/tMNo3oQ7wd0XKL7qqYdRy/9u6JwwqdH
 +o/imTEPXJlw7O1d/hDM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 11 April 2013, Sylwester Nawrocki wrote:
> On 04/11/2013 02:13 AM, Mauro Carvalho Chehab wrote:
> > Em Thu, 11 Apr 2013 02:04:53 +0200
> > Arnd Bergmann <arnd@arndb.de> escreveu:
> > 
> >> In multiplatform configurations, we cannot include headers
> >> provided by only the exynos platform. Fortunately a number
> >> of drivers that include those headers do not actually need
> >> them, so we can just remove the inclusions.
> >>
> >> Signed-off-by: Arnd Bergmann <arnd@arndb.de>
> >> Cc: linux-media@vger.kernel.org
> >> Cc: Mauro Carvalho Chehab <mchehab@redhat.com>
> > 
> > Acked-by: Mauro Carvalho Chehab <mchehab@redhat.com>
> 
> This patch is already queued in the media tree for 3.10, and it can
> be found in -next now.
> 

Ok, thanks! I'll drop it from my series then.

	Arnd
