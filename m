Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751750AbaIIERN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 00:17:13 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:47550 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750879AbaIIERM convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 00:17:12 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging:r8190_rtl8256: coding style: Fixed commenting
 style
Thread-Topic: [PATCH] staging:r8190_rtl8256: coding style: Fixed commenting
 style
Thread-Index: AQHPwDP+bARtbaiNf0iw9BILB8cv1JvpmPUAgA6wOWA=
Date: Tue, 9 Sep 2014 04:17:09 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF48F06@EU-MBX-04.mgc.mentorg.com>
References: <1408951527-29317-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140830205752.GA28515@kroah.com>
In-Reply-To: <20140830205752.GA28515@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Sunday, August 31, 2014 2:28 AM
To: Sharma, Sanjeev
Cc: devel@driverdev.osuosl.org; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:r8190_rtl8256: coding style: Fixed commenting style

On Mon, Aug 25, 2014 at 12:55:27PM +0530, Sanjeev Sharma wrote:
> This is a patch to the r8190_rtl8256.c file that fixes commenting 
> style Error
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8192u/r8190_rtl8256.c | 59 
> +++++++++++++++++---------------
>  1 file changed, 31 insertions(+), 28 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r8190_rtl8256.c 
> b/drivers/staging/rtl8192u/r8190_rtl8256.c
> index 43ed768..8fe35ad 100644
> --- a/drivers/staging/rtl8192u/r8190_rtl8256.c
> +++ b/drivers/staging/rtl8192u/r8190_rtl8256.c
> @@ -61,13 +61,15 @@ void PHY_SetRF8256Bandwidth(struct net_device *dev , HT_CHANNEL_WIDTH Bandwidth)
>  				break;
>  		case HT_CHANNEL_WIDTH_20_40:
>  				if (priv->card_8192_version == VERSION_819xU_A || priv->card_8192_version == VERSION_819xU_B) { /* 8256 D-cut, E-cut, xiong: consider it later! */
> -					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0b, bMask12Bits, 0x300); //phy para:3ba
> +					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0b, 
> +bMask12Bits, 0x300); /* phy para:3ba */
>  					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x2c, bMask12Bits, 0x3df);
>  					rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x0e, 
> bMask12Bits, 0x0a1);
>  
> -					//cosa add for sd3's request 01/23/2008
> +					/* cosa add for sd3's request 01/23/2008
> +					 *
> +					 */
>  					if (priv->chan == 3 || priv->chan == 9)
> -						//I need to set priv->chan whenever current channel changes
> +						/* I need to set priv->chan whenever current channel changes */
>  						rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x14, bMask12Bits, 0x59b);
>  					else
>  						rtl8192_phy_SetRFReg(dev, (RF90_RADIO_PATH_E)eRFPath, 0x14, 
> bMask12Bits, 0x5ab); @@ -91,11 +93,12 @@ void 
> PHY_SetRF8256Bandwidth(struct net_device *dev , HT_CHANNEL_WIDTH 
> Bandwidth)  void PHY_RF8256_Config(struct net_device *dev)  {
>  	struct r8192_priv *priv = ieee80211_priv(dev);
> -	// Initialize general global value
> -	//
> -	// TODO: Extend RF_PATH_C and RF_PATH_D in the future
> +	/* Initialize general global value
> +	 *
> +	 * TODO: Extend RF_PATH_C and RF_PATH_D in the future
> +	 */
>  	priv->NumTotalRFPath = RTL819X_TOTAL_RF_PATH;
> -	// Config BB and RF
> +	/* Config BB and RF */
>  	phy_RF8256_Config_ParaFile(dev);
>  }
>  
> /*--------------------------------------------------------------------
> ------ @@ -107,10 +110,11 @@ void PHY_RF8256_Config(struct net_device 
> *dev)  void phy_RF8256_Config_ParaFile(struct net_device *dev)  {
>  	u32	u4RegValue = 0;
> -	//static s1Byte				szRadioAFile[] = RTL819X_PHY_RADIO_A;
> -	//static s1Byte				szRadioBFile[] = RTL819X_PHY_RADIO_B;
> -	//static s1Byte				szRadioCFile[] = RTL819X_PHY_RADIO_C;
> -	//static s1Byte				szRadioDFile[] = RTL819X_PHY_RADIO_D;
> +	/* static s1Byte				szRadioAFile[] = RTL819X_PHY_RADIO_A;
> +	 * static s1Byte				szRadioBFile[] = RTL819X_PHY_RADIO_B;
> +	 * static s1Byte				szRadioCFile[] = RTL819X_PHY_RADIO_C;
> +	 * static s1Byte				szRadioDFile[] = RTL819X_PHY_RADIO_D;
> +	 */

Why not just remove stuff like this if it's not being used?

Same goes for other commented out code lines.

thanks,

greg k-h

Hi greg

submitted patch after removal of unwanted code 

thanks,

Sanjeev sharma
