Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932980AbaCQM1v (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 08:27:51 -0400
Received: from mx08-00178001.pphosted.com ([91.207.212.93]:54065 "EHLO
	mx08-00178001.pphosted.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932767AbaCQM1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 08:27:49 -0400
Message-ID: <5326EA0A.2030708@st.com>
Date: Mon, 17 Mar 2014 13:26:50 +0100
From: Maxime Coquelin <maxime.coquelin@st.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <srinivas.kandagatla@st.com>, <linux-arm-kernel@lists.infradead.org>
Cc: <lee.jones@linaro.com>, Patrice Chotard <patrice.chotard@st.com>,
        <kernel@stlinux.com>, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, <linux-kernel@vger.kernel.org>,
        <srinivas.kandagatla@gmail.com>, Russell King <linux@arm.linux.org.uk>,
        Stuart Menefy <stuart.menefy@st.com>
Subject: Re: [PATCH] MAINTAINERS: Update ARM STi maintainers
References: <1393846139-18088-1-git-send-email-srinivas.kandagatla@st.com>
In-Reply-To: <1393846139-18088-1-git-send-email-srinivas.kandagatla@st.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.201.23.80]
X-Proofpoint-Virus-Version: vendor=fsecure engine=2.50.10432:5.11.87,1.0.14,0.0.0000
 definitions=2014-03-16_02:2014-03-14,2014-03-16,1970-01-01 signatures=0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 03/03/2014 12:28 PM, srinivas.kandagatla@st.com wrote:
> From: Srinivas Kandagatla <srinivas.kandagatla@st.com>
>
> This patch adds Maxime and Patrice to ARM/STi maintainers list.
> As Stuart Menefy opted to be removed from the list, this patch removes
> his email from maintainers. Updated my email with private email address.

This is a gentle reminder.

Srinivas and Stuart ST addresses won't be accessible anymore in a couple 
of weeks.

Maybe the right maintainer is missing in the To list?

Thanks,
Maxime

>
> This patch also adds few more drivers to the list so that get_maintainer
> script can pick the right people to send patch to and avoid email
> bounces.
>
> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@st.com>
> CC: Stuart Menefy <stuart.menefy@st.com>
> CC: Maxime Coquelin <maxime.coquelin@st.com>
> CC: Patrice Chotard <patrice.chotard@st.com>
> ---
>   MAINTAINERS |   12 ++++++++++--
>   1 file changed, 10 insertions(+), 2 deletions(-)
>
> diff --git a/MAINTAINERS b/MAINTAINERS
> index 85b3dd8..0b74b45 100644
> --- a/MAINTAINERS
> +++ b/MAINTAINERS
> @@ -1275,13 +1275,21 @@ S:	Maintained
>   F:	drivers/clk/socfpga/
>
>   ARM/STI ARCHITECTURE
> -M:	Srinivas Kandagatla <srinivas.kandagatla@st.com>
> -M:	Stuart Menefy <stuart.menefy@st.com>
> +M:	Srinivas Kandagatla <srinivas.kandagatla@gmail.com>
> +M:	Maxime Coquelin <maxime.coquelin@st.com>
> +M:	Patrice Chotard <patrice.chotard@st.com>
>   L:	linux-arm-kernel@lists.infradead.org (moderated for non-subscribers)
>   L:	kernel@stlinux.com
>   W:	http://www.stlinux.com
>   S:	Maintained
>   F:	arch/arm/mach-sti/
> +F:	arch/arm/boot/dts/sti*
> +F:	drivers/clocksource/arm_global_timer.c
> +F:	drivers/reset/sti/
> +F:	drivers/pinctrl/pinctrl-st.c
> +F:	drivers/media/rc/st_rc.c
> +F:	drivers/i2c/busses/i2c-st.c
> +F:	drivers/tty/serial/st-asc.c
>
>   ARM/TECHNOLOGIC SYSTEMS TS7250 MACHINE SUPPORT
>   M:	Lennert Buytenhek <kernel@wantstofly.org>
>
