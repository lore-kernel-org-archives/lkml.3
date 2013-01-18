Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753963Ab3ARRHv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jan 2013 12:07:51 -0500
Received: from avon.wwwdotorg.org ([70.85.31.133]:38006 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751507Ab3ARRHt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jan 2013 12:07:49 -0500
Message-ID: <50F98162.3040401@wwwdotorg.org>
Date: Fri, 18 Jan 2013 10:07:46 -0700
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: gregkh@linuxfoundation.org, balbi@ti.com, stern@rowland.harvard.edu,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: Re: [PATCH 3/4] USB: PHY: Tegra: Get rid of instance number to differentiate
 PHY type
References: <1358343022-28919-1-git-send-email-vbyravarasu@nvidia.com> <1358343022-28919-4-git-send-email-vbyravarasu@nvidia.com> <50F98089.6040008@wwwdotorg.org>
In-Reply-To: <50F98089.6040008@wwwdotorg.org>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/18/2013 10:04 AM, Stephen Warren wrote:
> On 01/16/2013 06:30 AM, Venu Byravarasu wrote:
>> Tegra20 USB has 3 PHY instances:
>> Instance 1 and 3 are UTMI. Instance 2 is ULPI.
>>
>> As instance number was used to differentiate ULPI from UTMI,
>> used DT param to get this info and processed accordingly.
> 
>> diff --git a/include/linux/usb/tegra_usb_phy.h b/include/linux/usb/tegra_usb_phy.h
>> index f03e157..a6a89d4 100644
>> --- a/include/linux/usb/tegra_usb_phy.h
>> +++ b/include/linux/usb/tegra_usb_phy.h
>> @@ -60,6 +60,7 @@ struct tegra_usb_phy {
>>  	struct usb_phy u_phy;
>>  	struct device *dev;
>>  	bool is_legacy_phy;
>> +	bool is_ulpi_phy;
>>  };
> 
> I see the code that uses this new field, but it doesn't appear to be set
> anywhere...

Oh, I see that code ended up being part of patch 4. Can you please
repost the series with that chunk moved into patch 3 where it belongs?
