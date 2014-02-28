Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752939AbaB1PKG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 10:10:06 -0500
Received: from bear.ext.ti.com ([192.94.94.41]:43303 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752909AbaB1PKB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 10:10:01 -0500
Message-ID: <5310A6A6.6030803@ti.com>
Date: Fri, 28 Feb 2014 09:09:26 -0600
From: Nishanth Menon <nm@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Tony Lindgren <tony@atomide.com>, Chris Ball <chris@printf.net>
CC: Balaji T K <balajitk@ti.com>, <linux-mmc@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <devicetree@vger.kernel.org>, Felipe Balbi <balbi@ti.com>
Subject: Re: [PATCH V2 1/2] mmc: omap_hsmmc: Add support for quirky omap3
 hsmmc controller
References: <1392356749-32091-1-git-send-email-nm@ti.com> <1392356749-32091-2-git-send-email-nm@ti.com> <20140214163102.GA21592@atomide.com>
In-Reply-To: <20140214163102.GA21592@atomide.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/14/2014 10:31 AM, Tony Lindgren wrote:
> * Nishanth Menon <nm@ti.com> [140213 21:48]:
>> When device is booted using devicetree, platforms impacted by Erratum
>> 2.1.1.128 is not detected easily in the mmc driver. This erratum
>> indicates that the module cannot do multi-block transfers. Platforms
>> such as LDP which use OMAP3 ES revision prior to ES3.0 are impacted by
>> this.
>>
>> Provide a new compatible property "ti,omap3-pre-es3-hsmmc" to allow
>> driver to determine if driver needs to implement quirks associated
>> with the specific module version (primarily because the IP revision
>> information is not sufficient for the same).
>>
>> Signed-off-by: Nishanth Menon <nm@ti.com>
> 
> Looks good to me, would be good to get this into the -rc cycle
> as LDP is one of the automated boot testing boards for us.
> 
> If you guys want me to pick up both of the patches let me know,
> otherwise feel free to add my ack.
> 

Chris,
would you be picking up the series that fixes LDP dt boot behavior or
should Tony pick it up?

https://patchwork.kernel.org/patch/3650061/
https://patchwork.kernel.org/patch/3650031/


-- 
Regards,
Nishanth Menon
