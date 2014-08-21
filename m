Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753844AbaHUGcI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 02:32:08 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:34368 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753476AbaHUGcG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 02:32:06 -0400
Message-ID: <53F5925E.3010802@linaro.org>
Date: Thu, 21 Aug 2014 07:31:58 +0100
From: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-msm@vger.kernel.org
Subject: Re: [PATCH v2] usb: phy: msm: Make phy_reset clk and reset line optional.
References: <1405628200-21776-1-git-send-email-srinivas.kandagatla@linaro.org> <20140820155740.GF24500@saruman.home>
In-Reply-To: <20140820155740.GF24500@saruman.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks Felipe,

On 20/08/14 16:57, Felipe Balbi wrote:
> On Thu, Jul 17, 2014 at 09:16:40PM +0100, Srinivas Kandagatla wrote:
>> This patch makes the phy reset clk and reset line optional as this clk
>> is not available on boards like IFC6410 with APQ8064.
>>
>> phy-reset clk is only used as argument to the mach level callbacks, so
>> this patch adds condition before clk_get calls so that the driver
>> wouldn't fail on SOCs which do not have this support.
>>
>> Signed-off-by: Srinivas Kandagatla <srinivas.kandagatla@linaro.org>
>> ---
>> Hi Felipe,
>>
>> With this new patch now the error message is only printed if the SOC actually supports
>> the phy reset clk, for SOCs like APQ8064 where there is no phy reset clock or
>> the callback which takes it there is no point in doing a clk_get call in the first place.
>
> doesn't apply. Please rebase on top of v3.17-rc1
>
this is because a previous version of the same patch got applied.
Anyway I will rebase this patch and send v3.

thanks,
srini
