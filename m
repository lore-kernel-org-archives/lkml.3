Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933696Ab3LIN1q (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 08:27:46 -0500
Received: from mailout2.w1.samsung.com ([210.118.77.12]:19221 "EHLO
	mailout2.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933351Ab3LIN1n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 08:27:43 -0500
X-AuditID: cbfec7f4-b7f966d0000003d9-9a-52a5c54da351
From: Tomasz Figa <t.figa@samsung.com>
To: Daniel Kurtz <djkurtz@chromium.org>
Cc: Russell King <linux@arm.linux.org.uk>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Heiko Stuebner <heiko@sntech.de>,
        Amit Daniel Kachhap <amit.daniel@samsung.com>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org,
        Doug Andersen <dianders@chromium.org>
Subject: Re: [PATCH 2/3] ARM: SAMSUNG: Let s3c_pm_do_restore_*() take const
 sleep_save
Date: Mon, 09 Dec 2013 14:27:30 +0100
Message-id: <1388884.PZXKrtOKJT@amdc1227>
Organization: Samsung Poland R&D Center
User-Agent: KMail/4.11.3 (Linux/3.11.5-gentoo; KDE/4.11.3; x86_64; ; )
In-reply-to: <1384971686-7208-2-git-send-email-djkurtz@chromium.org>
References: <1384971686-7208-1-git-send-email-djkurtz@chromium.org>
 <1384971686-7208-2-git-send-email-djkurtz@chromium.org>
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFnrMLMWRmVeSWpSXmKPExsVy+t/xa7q+R5cGGcydJGPxeM1iJouGqyEW
	k9YdYLI4u+wgm0XjjPmsFv8fvWa16F1wlc1i0+NrrBaXd81hs5hxfh+Txe3LvA7cHi3NPWwe
	sxsusnj8XfWC2WPzknqPvi2rGD22X5vH7PF5k1wAexSXTUpqTmZZapG+XQJXxrkpCQVTWSv+
	tN5iaWDsYOli5OSQEDCR2Pb0FBOELSZx4d56ti5GLg4hgaWMEp8eNDFBOF1MEqdf7mIFqWIT
	UJP43PAIqIqDQ0RAXeLXDSeQGmaBRmaJW8/3g00SFoiQ+H17NjOIzSKgKtHV9JsFpJ5XQFPi
	/RV5kDA/UOu7bU/BykUF3CRe7NvCDmJzCrhIHD77kRHEFhKolVixbA4biM0rICjxY/I9sKOZ
	BeQl9u2fygpha0ms33mcaQKj4CwkZbOQlM1CUraAkXkVo2hqaXJBcVJ6rqFecWJucWleul5y
	fu4mRkjEfNnBuPiY1SFGAQ5GJR7eFaxLg4RYE8uKK3MPMUpwMCuJ8IrtAgrxpiRWVqUW5ccX
	leakFh9iZOLglGpgFNa5+mC+41s+dVHG6y0TkxyL3f28BC1cb+4XESt55Pd7IV9YTT9L7NOF
	P8u7Zrx9NNUqbJbrV9Yi/qhTX05/MJlTWZzvXHRaRWyatd2i9IIp/VVLvvqLqxZc8RF9+3VB
	4cqXc9nq6/5eW6i09GDSvot1bNHvprzvZb7iZ9t2uORKiPuZva7WSizFGYmGWsxFxYkAkUUt
	jXYCAAA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Daniel,

On Thursday 21 of November 2013 02:21:25 Daniel Kurtz wrote:
> The restore functions do not modify the passed in struct sleep_save,
> so that parameter can be const.
> 
> This allows us to pass in const struct.  This allows us to use const
> structs sleep_save to define system registers that will always be
> restored to a constant value.
> 
> Signed-off-by: Daniel Kurtz <djkurtz@chromium.org>
> ---
>  arch/arm/plat-samsung/include/plat/pm.h | 4 ++--
>  arch/arm/plat-samsung/pm.c              | 4 ++--
>  2 files changed, 4 insertions(+), 4 deletions(-)

Reviewed-by: Tomasz Figa <t.figa@samsung.com>

Best regards,
Tomasz

