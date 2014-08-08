Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753144AbaHHELd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 00:11:33 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:57150 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750889AbaHHELb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 00:11:31 -0400
From: "Sharma, Sanjeev" <Sanjeev_Sharma@mentor.com>
To: Greg KH <gregkh@linuxfoundation.org>
CC: "devel@driverdev.osuosl.org" <devel@driverdev.osuosl.org>,
        "oort10@gmail.com" <oort10@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: RE: [PATCH] staging:r819xU: coding style: Fixed commenting style
Thread-Topic: [PATCH] staging:r819xU: coding style: Fixed commenting style
Thread-Index: AQHPsgly3szt5P2MVE+Y/yDRZN6SZpvFPVcAgADb4IA=
Date: Fri, 8 Aug 2014 04:11:28 +0000
Message-ID: <FDC088D3B5555644AE135ED28A7ABDE94DF259BF@EU-MBX-02.mgc.mentorg.com>
References: <1407393957-27948-1-git-send-email-sanjeev_sharma@mentor.com>
 <20140807160312.GA8014@kroah.com>
In-Reply-To: <20140807160312.GA8014@kroah.com>
Accept-Language: en-US
Content-Language: en-US
X-MS-Has-Attach: 
X-MS-TNEF-Correlator: 
x-originating-ip: [137.202.0.76]
Content-Type: text/plain; charset="us-ascii"
Content-Transfer-Encoding: 8BIT
MIME-Version: 1.0
X-OriginalArrivalTime: 08 Aug 2014 04:11:30.0695 (UTC) FILETIME=[D52B5170:01CFB2BE]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Opps, I forget.

Let me correct and send V2 patch.

Regards
Sanjeev Sharma

-----Original Message-----
From: Greg KH [mailto:gregkh@linuxfoundation.org] 
Sent: Thursday, August 07, 2014 9:33 PM
To: Sharma, Sanjeev
Cc: devel@driverdev.osuosl.org; oort10@gmail.com; linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging:r819xU: coding style: Fixed commenting style

On Thu, Aug 07, 2014 at 12:15:57PM +0530, Sanjeev Sharma wrote:
> This is a patch to the r819xU_phyreg.h file that fixes commenting 
> style warning
> 
> Signed-off-by: Sanjeev Sharma <Sanjeev_Sharma@mentor.com>
> ---
>  drivers/staging/rtl8192u/r819xU_phyreg.h | 188 
> ++++++++++++++++---------------
>  1 file changed, 97 insertions(+), 91 deletions(-)
> 
> diff --git a/drivers/staging/rtl8192u/r819xU_phyreg.h 
> b/drivers/staging/rtl8192u/r819xU_phyreg.h
> index 64285d6..f07d2f1 100644
> --- a/drivers/staging/rtl8192u/r819xU_phyreg.h
> +++ b/drivers/staging/rtl8192u/r819xU_phyreg.h
> @@ -2,10 +2,10 @@
>  #define _R819XU_PHYREG_H
>  
>  
> -#define   RF_DATA				0x1d4					// FW will write RF data in the register.
> +#define   RF_DATA				0x1d4					/* FW will write RF data in the register.*/
>  
> -//Register   //duplicate register due to connection: RF_Mode, TRxRN, NumOf L-STF
> -//page 1
> +/* Register   //duplicate register due to connection: RF_Mode, TRxRN, NumOf L-STF */

Does that line look correct?

