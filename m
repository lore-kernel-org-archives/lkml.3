Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755642Ab3JKNNq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 09:13:46 -0400
Received: from mail-ea0-f177.google.com ([209.85.215.177]:46602 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751890Ab3JKNNo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 09:13:44 -0400
Message-ID: <5257F983.9060904@gmail.com>
Date: Fri, 11 Oct 2013 15:13:39 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Tomasz Figa <tomasz.figa@gmail.com>
CC: linux-samsung-soc@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        linux-media@vger.kernel.org, alsa-devel@alsa-project.org,
        Kukjin Kim <kgene.kim@samsung.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Ben Dooks <ben-linux@fluff.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Sangbeom Kim <sbkim73@samsung.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Jaroslav Kysela <perex@perex.cz>, Takashi Iwai <tiwai@suse.de>,
        Sylwester Nawrocki <s.nawrocki@samsung.com>,
        Geert Uytterhoeven <geert@linux-m68k.org>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>
Subject: Re: [PATCH 3/5] [media] s3c-camif: Use CONFIG_ARCH_S3C64XX to check
 for S3C64xx support
References: <1380392497-27406-1-git-send-email-tomasz.figa@gmail.com> <1380392497-27406-3-git-send-email-tomasz.figa@gmail.com>
In-Reply-To: <1380392497-27406-3-git-send-email-tomasz.figa@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/28/2013 08:21 PM, Tomasz Figa wrote:
> Since CONFIG_PLAT_S3C64XX is going to be removed, this patch modifies
> the Kconfig entry of s3c-camif driver to use the proper way of checking
> for S3C64xx support - CONFIG_ARCH_S3C64XX.
>
> Signed-off-by: Tomasz Figa<tomasz.figa@gmail.com>

Acked-by: Sylwester Nawrocki <s.nawrocki@samsung.com>
