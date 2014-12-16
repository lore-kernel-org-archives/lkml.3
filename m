Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751015AbaLPOCW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Dec 2014 09:02:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:51612 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750814AbaLPOCU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Dec 2014 09:02:20 -0500
From: Jes Sorensen <Jes.Sorensen@redhat.com>
To: Asaf Vertz <asaf.vertz@tandemg.com>
Cc: Larry.Finger@lwfinger.net, gregkh@linuxfoundation.org, ninox@posteo.net,
        tapaswenipathak@gmail.com, gdonald@gmail.com, cmroliv@gmail.com,
        linux-wireless@vger.kernel.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] staging: rtl8723au: core: fixing "foo * bar" should be "foo *bar"
References: <20141216135758.GA32288@ubuntu>
Date: Tue, 16 Dec 2014 09:01:45 -0500
In-Reply-To: <20141216135758.GA32288@ubuntu> (Asaf Vertz's message of "Tue, 16
	Dec 2014 15:57:58 +0200")
Message-ID: <wrfjoar31ynq.fsf@redhat.com>
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
> Changes in v2:
>   - fix ugly multiline arguments to the functions
>
>  drivers/staging/rtl8723au/core/rtw_efuse.c |   32 ++++++---------------------
>  1 files changed, 7 insertions(+), 25 deletions(-)

Signed-off-by: Jes Sorensen <Jes.Sorensen@redhat.com>

> diff --git a/drivers/staging/rtl8723au/core/rtw_efuse.c b/drivers/staging/rtl8723au/core/rtw_efuse.c
> index 81960e7..a6deddc 100644
> --- a/drivers/staging/rtl8723au/core/rtw_efuse.c
> +++ b/drivers/staging/rtl8723au/core/rtw_efuse.c
> @@ -327,15 +327,9 @@ EFUSE_Read1Byte23a(struct rtw_adapter *Adapter, u16 Address)
>   *---------------------------------------------------------------------------*/
>  
>  void
> -EFUSE_Write1Byte(
> -	struct rtw_adapter *	Adapter,
> -	u16		Address,
> -	u8		Value);
> +EFUSE_Write1Byte(struct rtw_adapter *Adapter, u16 Address, u8 Value);
>  void
> -EFUSE_Write1Byte(
> -	struct rtw_adapter *	Adapter,
> -	u16		Address,
> -	u8		Value)
> +EFUSE_Write1Byte(struct rtw_adapter *Adapter, u16 Address, u8 Value)
>  {
>  	u8	Bytetemp = {0x00};
>  	u8	temp = {0x00};
> @@ -635,10 +629,7 @@ Efuse_ReadAllMap(struct rtw_adapter *pAdapter, u8 efuseType, u8 *Efuse)
>   *
>   *---------------------------------------------------------------------------*/
>  static void
> -efuse_ShadowRead1Byte(
> -	struct rtw_adapter *	pAdapter,
> -	u16		Offset,
> -	u8		*Value)
> +efuse_ShadowRead1Byte(struct rtw_adapter *pAdapter, u16 Offset, u8 *Value)
>  {
>  	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
>  
> @@ -647,10 +638,7 @@ efuse_ShadowRead1Byte(
>  
>  /* Read Two Bytes */
>  static void
> -efuse_ShadowRead2Byte(
> -	struct rtw_adapter *	pAdapter,
> -	u16		Offset,
> -	u16		*Value)
> +efuse_ShadowRead2Byte(struct rtw_adapter *pAdapter, u16 Offset, u16 *Value)
>  {
>  	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
>  
> @@ -660,10 +648,7 @@ efuse_ShadowRead2Byte(
>  
>  /* Read Four Bytes */
>  static void
> -efuse_ShadowRead4Byte(
> -	struct rtw_adapter *	pAdapter,
> -	u16		Offset,
> -	u32		*Value)
> +efuse_ShadowRead4Byte(struct rtw_adapter *pAdapter, u16 Offset, u32 *Value)
>  {
>  	struct eeprom_priv *pEEPROM = GET_EEPROM_EFUSE_PRIV(pAdapter);
>  
> @@ -722,11 +707,8 @@ void EFUSE_ShadowMapUpdate23a(struct rtw_adapter *pAdapter, u8 efuseType)
>   *
>   *---------------------------------------------------------------------------*/
>  void
> -EFUSE_ShadowRead23a(
> -	struct rtw_adapter *	pAdapter,
> -	u8		Type,
> -	u16		Offset,
> -	u32		*Value)
> +EFUSE_ShadowRead23a(struct rtw_adapter *pAdapter,
> +		    u8 Type, u16 Offset, u32 *Value)
>  {
>  	if (Type == 1)
>  		efuse_ShadowRead1Byte(pAdapter, Offset, (u8 *)Value);
