Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757001Ab3HZQUl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 12:20:41 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:37140 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751973Ab3HZQUk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 12:20:40 -0400
Date: Mon, 26 Aug 2013 19:20:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Iker Pedrosa <ikerpedrosam@gmail.com>
Cc: pavel@ucw.cz, devel@driverdev.osuosl.org, gregkh@linuxfoundation.org,
        harsh1kumar@gmail.com, linux-kernel@vger.kernel.org,
        mujeeb.adil@gmail.com, justinmattock@gmail.com
Subject: Re: [PATCH 09/24] Staging: winbond: reg: fixed some lines over 80
 characters
Message-ID: <20130826162020.GE6329@mwanda>
References: <1377529823-5116-1-git-send-email-ikerpedrosam@gmail.com>
 <1377529823-5116-10-git-send-email-ikerpedrosam@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377529823-5116-10-git-send-email-ikerpedrosam@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 26, 2013 at 05:10:08PM +0200, Iker Pedrosa wrote:
> @@ -926,7 +928,8 @@ static void Set_ChanIndep_RfData_al7230_24(struct hw_data *pHwData, u32 *pltmp,
>  	u8	i;
>  	for (i = 0; i < number; i++) {
>  		pHwData->phy_para[i] = al7230_rf_data_24[i];
> -		pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24) | (al7230_rf_data_24[i] & 0xffffff);
> +		pltmp[i] = (1 << 31) | (0 << 30) | (24 << 24)
> +				   | (al7230_rf_data_24[i] & 0xffffff);

It's always a bit hard for me to know how picky to be.  Normally the '|'
would be on the first line here.

regards,
dan carpenter

