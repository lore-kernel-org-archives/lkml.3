Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753972Ab3LGIQu (ORCPT <rfc822;w@1wt.eu>);
	Sat, 7 Dec 2013 03:16:50 -0500
Received: from mail-bk0-f42.google.com ([209.85.214.42]:41283 "EHLO
	mail-bk0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752021Ab3LGIQs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 7 Dec 2013 03:16:48 -0500
Message-ID: <52A2D96D.5010407@linux.com>
Date: Sat, 07 Dec 2013 09:16:45 +0100
From: Levente Kurusa <levex@linux.com>
Reply-To: Levente Kurusa <levex@linux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Gary Rookard <garyrookard@gmail.com>, gregkh@linuxfoundation.org
CC: lisa@xenapiadmin.com, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/9] Staging: bcm: DDRInit: replaced C99 comments.
References: <1386391955-11713-1-git-send-email-garyrookard@gmail.com>
In-Reply-To: <1386391955-11713-1-git-send-email-garyrookard@gmail.com>
Content-Type: text/plain; charset=ISO-8859-2; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

A few comments, see below please.

2013-12-07 05:52, Gary Rookard:
> This is the fifth patch of a series.
>
> Signed-off-by: Gary Alan Rookard <garyrookard@gmail.com>
> ---
> On branch staging-next
>   drivers/staging/bcm/DDRInit.c | 270 +++++++++++++++++++++---------------------
>   1 file changed, 135 insertions(+), 135 deletions(-)
>
> diff --git a/drivers/staging/bcm/DDRInit.c b/drivers/staging/bcm/DDRInit.c
> index cb4dd53..1a08b17 100644
> --- a/drivers/staging/bcm/DDRInit.c
> +++ b/drivers/staging/bcm/DDRInit.c
> @@ -5,15 +5,15 @@
>   #define DDR_DUMP_INTERNAL_DEVICE_MEMORY 0xBFC02B00
>   #define MIPS_CLOCK_REG 	0x0f000820
>
> -    //DDR INIT-133Mhz
> -#define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  //index for 0x0F007000
> -static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {//      # DPLL Clock Setting
> +    /* DDR INIT-133Mhz */
> +#define T3_SKIP_CLOCK_PROGRAM_DUMP_133MHZ 12  /* index for 0x0F00700 */0
> +static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {     /* # DPLL Clock Setting */

Why not remove the '#'? It is useless and never used anywhere else.
There is a /0 after... Have you build-test it?

> @@ -29,17 +29,17 @@ static struct bcm_ddr_setting asT3_DDRSetting133MHz[] = {//      # DPLL Clock Se
>   	{0x0F007010, 0x01000000},
>   	{0x0F007014, 0x01000100},
>   	{0x0F007018, 0x01000000},
> -	{0x0F00701c, 0x01020001},// POP - 0x00020001 Normal 0x01020001
> -	{0x0F007020, 0x04030107}, //Normal - 0x04030107 POP - 0x05030107
> +	{0x0F00701c, 0x01020001},/*  POP - 0x00020001 Normal 0x01020001 */
> +	{0x0F007020, 0x04030107}, /* Normal - 0x04030107 POP - 0x05030107 */
>   	{0x0F007024, 0x02000007},
>   	{0x0F007028, 0x02020202},
> -	{0x0F00702c, 0x0206060a},//ROB- 0x0205050a,//0x0206060a
> +	{0x0F00702c, 0x0206060a},/* ROB- 0x0205050a,0x0206060a */
>   	{0x0F007030, 0x05000000},
>   	{0x0F007034, 0x00000003};
> -	{0x0F007038, 0x110a0200},//ROB - 0x110a0200,//0x180a0200,// 0x1f0a0200
> -	{0x0F00703C, 0x02101010},//ROB - 0x02101010,//0x02101018},
> -	{0x0F007040, 0x45751200},//ROB - 0x45751200,//0x450f1200},
> -	{0x0F007044, 0x110a0d00},//ROB - 0x110a0d00//0x111f0d00
> +	{0x0F007038, 0x110a0200},/* ROB - 0x110a0200,0x180a0200,0x1f0a0200 */
> +	{0x0F00703C, 0x02101010},/* ROB - 0x02101010,0x02101018}, */
> +	{0x0F007040, 0x45751200},/* ROB - 0x45751200,0x450f1200}, */
> +	{0x0F007044, 0x110a0d00},/*ROB - 0x110a0d00.0x111f0d00 */

No space after '/*'

> @@ -112,19 +112,19 @@ static struct bcm_ddr_setting asT3_DDRSetting80MHz[] = {//   # DPLL Clock Settin
>   	{0x0F007080, 0x00000000},
>   	{0x0F007084, 0x00000000},
>   	{0x0F007094, 0x00000104},
> -                                        //# Enable start bit within memory controller
> +                                        /*# Enable start bit within memory controller */

Again, no space and there is that '#' which looks pretty bad.


-- 
Regards,
Levente Kurusa
