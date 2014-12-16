Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751357AbaLPMn4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 07:43:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40255 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750882AbaLPMnz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 07:43:55 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Asaf Vertz <asaf.vertz@tandemg.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org, ninox@posteo.net,
        tapaswenipathak@gmail.com, gdonald@gmail.com, cmroliv@gmail.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: rtl8723au: core: fixing "foo * bar" should be "foo *bar"
References: <20141216091323.GA28072@ubuntu>
Date: Tue, 16 Dec 2014 07:43:34 -0500
In-Reply-To: <20141216091323.GA28072@ubuntu> (Asaf Vertz's message of "Tue, 16
	Dec 2014 11:13:23 +0200")
Message-ID: <wrfjy4q7pxxl.fsf@redhat.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Asaf Vertz <asaf.vertz@tandemg.com> writes:
> Fixed a coding style error, "foo * bar" should be "foo *bar"
>
> Signed-off-by: Asaf Vertz <asaf.vertz@tandemg.com>
> ---
>  drivers/staging/rtl8723au/core/rtw_efuse.c |   12 ++++++------
>  1 files changed, 6 insertions(+), 6 deletions(-)

If you want to fix the 'error' here, include it with a cleanup that also
fixes the ugly multiline arguments to the functions.

Jes

> diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
> index 81960e7..0e64d12 100644
> --- a/drivers/staging/rtl8723au/core/rtw_efuse.c
> +++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
> @@ -328,12 +328,12 @@ EFUSE_Read1Byte23a(struct rtw_adapter *Adapter, u16 Address)
>  
>  void
>  EFUSE_Write1Byte(
> -	struct rtw_adapter *	Adapter,
> +	struct rtw_adapter *Adapter,
>  	u16		Address,
>  	u8		Value);
>  void
>  EFUSE_Write1Byte(
> -	struct rtw_adapter *	Adapter,
> +	struct rtw_adapter *Adapter,
>  	u16		Address,
>  	u8		Value)
>  {
> @@ -636,7 +636,7 @@ Efuse_ReadAllMap(struct rtw_adapter *pAdapter, u8 efuseType, u8 *Efuse)
>   *---------------------------------------------------------------------------*/
>  static void
>  efuse_ShadowRead1Byte(
> -	struct rtw_adapter *	pAdapter,
> +	struct rtw_adapter *pAdapter,
>  	u16		Offset,
>  	u8		*Value)
>  {
> @@ -648,7 +648,7 @@ efuse_ShadowRead1Byte(
>  /* Read Two Bytes */
>  static void
>  efuse_ShadowRead2Byte(
> -	struct rtw_adapter *	pAdapter,
> +	struct rtw_adapter *pAdapter,
>  	u16		Offset,
>  	u16		*Value)
>  {
> @@ -661,7 +661,7 @@ efuse_ShadowRead2Byte(
>  /* Read Four Bytes */
>  static void
>  efuse_ShadowRead4Byte(
> -	struct rtw_adapter *	pAdapter,
> +	struct rtw_adapter *pAdapter,
>  	u16		Offset,
>  	u32		*Value)
>  {
> @@ -723,7 +723,7 @@ void EFUSE_ShadowMapUpdate23a(struct rtw_adapter *pAdapter, u8 efuseType)
>   *---------------------------------------------------------------------------*/
>  void
>  EFUSE_ShadowRead23a(
> -	struct rtw_adapter *	pAdapter,
> +	struct rtw_adapter *pAdapter,
>  	u8		Type,
>  	u16		Offset,
>  	u32		*Value)
