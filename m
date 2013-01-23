Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754329Ab3AWJca (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 04:32:30 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:37316 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753641Ab3AWJc2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 04:32:28 -0500
Message-ID: <50FFAE28.3070003@ti.com>
Date: Wed, 23 Jan 2013 11:32:24 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: Venu Byravarasu <vbyravarasu@nvidia.com>
CC: "balbi@ti.com" <balbi@ti.com>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2] usb: phy: moving all PHY API definitions to usb/phy
 directory
References: <1358852471-28260-1-git-send-email-vbyravarasu@nvidia.com> <50FEA059.7080903@ti.com> <D958900912E20642BCBC71664EFECE3E6E1B13B787@BGMAIL02.nvidia.com>
In-Reply-To: <D958900912E20642BCBC71664EFECE3E6E1B13B787@BGMAIL02.nvidia.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2013 01:56 AM, Venu Byravarasu wrote:
>> -----Original Message-----
>> From: Roger Quadros [mailto:rogerq@ti.com]
>> Sent: Tuesday, January 22, 2013 7:51 PM
>> To: Venu Byravarasu
>> Cc: balbi@ti.com; gregkh@linuxfoundation.org; linux-usb@vger.kernel.org;
>> linux-kernel@vger.kernel.org
>> Subject: Re: [PATCH v2] usb: phy: moving all PHY API definitions to usb/phy
>> directory
>>
>> On 01/22/2013 01:01 PM, Venu Byravarasu wrote:
>>> As drivers/usb/otg/otg.c contains most of the PHY related APIs
>>> which are not OTG specific, moving them to more logical place
>>> under driver/usb/phy.
>>>
>>> Signed-off-by: Venu Byravarasu <vbyravarasu@nvidia.com>
>>> ---
>>> delta from v1:
>>> Missed adding newly created file usb_phy.c with previous patch.
>>> hence sending v2, after adding that.
>>>
>>>  drivers/usb/otg/otg.c                    |  184 ------------------------------
>>>  drivers/usb/phy/Makefile                 |    1 +
>>>  drivers/usb/{otg/otg.c => phy/usb_phy.c} |   45 +-------
>>>  3 files changed, 6 insertions(+), 224 deletions(-)
>>>  copy drivers/usb/{otg/otg.c => phy/usb_phy.c} (82%)
>>
>> what about updating
>> drivers/usb/otg/Makefile and Kconfig?
>>
>> i.e. remove CONFIG_USB_OTG_UTILS and otg.o there?
> 
> Thanks for your comments.
> Those files may still be needed, as we're not removing otg.c,
> due to remaining only otg function i.e. otg_state_string().
> 

Oh yes, in that case it is fine.

--
cheers,
-roger.
