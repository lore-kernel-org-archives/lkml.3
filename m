Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760940Ab3DBNKf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 09:10:35 -0400
Received: from eu1sys200aog105.obsmtp.com ([207.126.144.119]:56417 "EHLO
	eu1sys200aog105.obsmtp.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1760445Ab3DBNKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 09:10:34 -0400
Message-ID: <515AD8BC.5050206@stericsson.com>
Date: Tue, 2 Apr 2013 15:10:20 +0200
From: =?UTF-8?B?QmVuZ3QgSsO2bnNzb24=?= <bengt.g.jonsson@stericsson.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Axel Lin <axel.lin@ingics.com>
Cc: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        Lee Jones <lee.jones@linaro.org>,
        Yvan FILLION <yvan.fillion@stericsson.com>,
        Liam Girdwood <lgirdwood@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] regulator: dbx500-prcmu: Remove operating_point from
 struct dbx500_regulator_info
References: <1364908104.9803.3.camel@phoenix>
In-Reply-To: <1364908104.9803.3.camel@phoenix>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/02/2013 03:08 PM, Axel Lin wrote:
> operating_point is not used since the initial commit of db8500-prcmu driver,
> remove it.
>
> Signed-off-by: Axel Lin <axel.lin@ingics.com>
Acked-by: Bengt Jonsson <bengt.g.jonsson@stericsson.com>
> ---
>   drivers/regulator/dbx500-prcmu.h |    2 --
>   1 file changed, 2 deletions(-)
>
> diff --git a/drivers/regulator/dbx500-prcmu.h b/drivers/regulator/dbx500-prcmu.h
> index e763883..c8e51ac 100644
> --- a/drivers/regulator/dbx500-prcmu.h
> +++ b/drivers/regulator/dbx500-prcmu.h
> @@ -21,7 +21,6 @@
>    * @is_enabled: status of the regulator
>    * @epod_id: id for EPOD (power domain)
>    * @is_ramret: RAM retention switch for EPOD (power domain)
> - * @operating_point: operating point (only for vape, to be removed)
>    *
>    */
>   struct dbx500_regulator_info {
> @@ -32,7 +31,6 @@ struct dbx500_regulator_info {
>   	u16 epod_id;
>   	bool is_ramret;
>   	bool exclude_from_power_state;
> -	unsigned int operating_point;
>   };
>   
>   void power_state_active_enable(void);

