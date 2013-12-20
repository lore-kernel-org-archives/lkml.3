Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754249Ab3LTVI6 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 16:08:58 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:61228 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752629Ab3LTVI4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 16:08:56 -0500
Message-ID: <52B4B1E3.2020108@samsung.com>
Date: Sat, 21 Dec 2013 06:08:51 +0900
From: Kukjin Kim <kgene.kim@samsung.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.24) Gecko/20111108 Fedora/3.1.16-1.fc14 Lightning/1.0b3pre Thunderbird/3.1.16
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>
CC: Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Simon Glass <sjg@chromium.org>, Samuel Ortiz <sameo@linux.intel.com>,
        Olof Johansson <olof@lixom.net>, Kukjin Kim <kgene.kim@samsung.com>,
        Ben Dooks <ben-linux@fluff.org>, Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] ARM: dts: Add the missing "\" key in non-US keyboards
 for exynos5250-snow
References: <1387492578-22068-1-git-send-email-dianders@chromium.org> <1387492578-22068-2-git-send-email-dianders@chromium.org>
In-Reply-To: <1387492578-22068-2-git-send-email-dianders@chromium.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/20/13 07:36, Doug Anderson wrote:
> When the exynos5250 device tree was sent upstream the keyboard mapping
> was missing the 2nd instance of the "\" key.  There are two copies of
> the "\" because it simply has a different row and column on US and
> non-US keyboards.
>
> For more details, see the previous patch in this series: (mkbp: Fix
> problems with backslash).
>
> Signed-off-by: Doug Anderson<dianders@chromium.org>
> ---
>   arch/arm/boot/dts/exynos5250-snow.dts | 1 +
>   1 file changed, 1 insertion(+)
>
> diff --git a/arch/arm/boot/dts/exynos5250-snow.dts b/arch/arm/boot/dts/exynos5250-snow.dts
> index fd711e2..28fe2e2 100644
> --- a/arch/arm/boot/dts/exynos5250-snow.dts
> +++ b/arch/arm/boot/dts/exynos5250-snow.dts
> @@ -130,6 +130,7 @@
>   							0x04060024	/* J */
>   							0x04080027	/* ; */
>   							0x04090026	/* L */
> +							0x040a002b	/* \ */
>   							0x040b001c	/* ENTER */
>
>   							0x0501002c	/* Z */

OK, Applied this(2/3) and next one(3/3) into fixes for v3.14.

If these patches should be sent for 3.13 or before, please let me know.

Thanks and Merry Christmas ;-)

- Kukjin
