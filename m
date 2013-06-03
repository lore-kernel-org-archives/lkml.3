Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756818Ab3FCLky (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 07:40:54 -0400
Received: from mailout2.w1.samsung.com ([210.118.77.12]:9307 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753958Ab3FCLkx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 07:40:53 -0400
X-AuditID: cbfec7f4-b7fd76d0000035e1-2f-51ac80c2b273
From: Tomasz Figa <t.figa@samsung.com>
To: Tushar Behera <tushar.behera@linaro.org>
Cc: t.figa@gmail.com, Sylwester Nawrocki <sylvester.nawrocki@gmail.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, arnd@arndb.de,
        kgene.kim@samsung.com, olof@lixom.net, patches@linaro.org
Subject: Re: [PATCH 3/3] ARM: S5P64X0: Remove duplicate uncompress code
Date: Mon, 03 Jun 2013 13:40:49 +0200
Message-id: <13570629.4jzYey0dyq@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.10.2 (Linux/3.8.8-gentoo; KDE/4.10.2; x86_64; ; )
In-reply-to: <51AC18FF.9010108@linaro.org>
References: <1370000944-19786-1-git-send-email-tushar.behera@linaro.org>
 <51A9B3BC.9000405@gmail.com> <51AC18FF.9010108@linaro.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrCLMWRmVeSWpSXmKPExsVy+t/xq7qHGtYEGrw5ZW3xd9IxdoveBVfZ
	LDY9vsZqcXnXHDaLGef3MVmcuv6ZzWLK4S8sFvM+72SyOL97JpNF+9+9bA5cHr9/TWL02Dnr
	LrvHnWt72Dw2L6n3uHKiidWjb8sqRo/Pm+QC2KO4bFJSczLLUov07RK4Mq63zmUtOM1T8W3/
	atYGxl+cXYycHBICJhKfdl9mhrDFJC7cW8/WxcjFISSwlFFiXt8VFgini0niz50P7CBVbAJq
	Ep8bHrGB2CICOhIPFu0FK2IW+McoseTHISaQhLCAu8TbexvBxrIIqEo8+trLAmLzCmhJtKw6
	CzaIX0Bd4t22p2D1ogKuEh/2PwMbyglUc/5YCyPE5lZGiSNLm6GaBSV+TL4HZjMLyEvs2z+V
	FcLWkli/8zjTBEbBWUjKZiEpm4WkbAEj8ypG0dTS5ILipPRcQ73ixNzi0rx0veT83E2MkJj5
	soNx8TGrQ4wCHIxKPLyBHmsChVgTy4orcw8xSnAwK4nwXgkECvGmJFZWpRblxxeV5qQWH2Jk
	4uCUamCcy+Lo93472+kDy0tnHWW2/numfj9/38YZC5IisrZ3ua2uLEq7HvEmuShBKb83JKTg
	+I7J989WvGSrtaud2SQR6Ze8Re/S3yZFz2gtxjliut3LnzZuCjVv/fXpwcmHc32lzghOX+0u
	6aF7a9q8N95lS/xXbOY5WPL7WmuIRV6EIWuR+UL7D4uVWIozEg21mIuKEwHMahmbdwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Tushar,

On Monday 03 of June 2013 09:48:07 Tushar Behera wrote:
> On 06/01/2013 02:11 PM, Sylwester Nawrocki wrote:
> > Hi,
> > 
> > On 05/31/2013 01:49 PM, Tushar Behera wrote:
> >> The uncompress code in S5P64X0 is almost same as the uncompress code
> >> defined in plat-samsung. Better to reuse that code.
> >> 
> >> Signed-off-by: Tushar Behera<tushar.behera@linaro.org>
> >> ---
> >> 
> >>   arch/arm/mach-s5p64x0/include/mach/uncompress.h |  163
> >> 
> >> ++---------------------
> >> 
> >>   1 file changed, 8 insertions(+), 155 deletions(-)
> > 
> > Not sure if you are aware of it, Tomasz has already posted a patch that
> > removes this duplicated code: https://patchwork.kernel.org/patch/2589331
> > I think that patch is not yet merged though.
> > 
> > Regards,
> > Sylwester
> 
> Tomasz,
> 
> I had somehow missed that mail.
> 
> The patch that I have additionally makes calculation of uart_base
> conditional on DEBUG_LL in line with the rest of the patches.
> 
> Would you mind re-spining your patch with those changes?
> 
> Alternately, I can take your patch and do above modifications in them.

Unfortunately I'm unlikely to find time to do it myself in nearest future, so 
feel free to do it. Thanks.

Keep in mind, however, that this patch was a dependency of

[PATCH 0/6] Samsung watchdog support clean-up
http://thread.gmane.org/gmane.linux.kernel.samsung-soc/18736/focus=18951

so I would like to keep this series applicable.

Best regards,
-- 
Tomasz Figa
Linux Kernel Developer
Samsung R&D Institute Poland
Samsung Electronics

