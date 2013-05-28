Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932811Ab3E1F2i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 01:28:38 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49170 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932629Ab3E1F2g (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 01:28:36 -0400
Message-ID: <51A44029.2020106@ti.com>
Date: Tue, 28 May 2013 10:57:05 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Chanwoo Choi <cw00.choi@samsung.com>, <balbi@ti.com>
CC: <myungjoo.ham@samsung.com>, <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>,
        <lgirdwood@gmail.com>, <broonie@kernel.org>,
        <devicetree-discuss@lists.ozlabs.org>, <linux-doc@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <grant.likely@linaro.org>,
        <rob.herring@calxeda.com>, <rob@landley.net>,
        <gregkh@linuxfoundation.org>, <george.cherian@ti.com>,
        <sameo@linux.intel.com>
Subject: Re: [PATCH v2] usb: dwc3: use extcon fwrk to receive connect/disconnect
 notification
References: <1369405896-30246-1-git-send-email-kishon@ti.com> <1369661740-15966-1-git-send-email-kishon@ti.com> <51A41559.20808@samsung.com>
In-Reply-To: <51A41559.20808@samsung.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday 28 May 2013 07:54 AM, Chanwoo Choi wrote:
> On 05/27/2013 10:35 PM, Kishon Vijay Abraham I wrote:
>> Modified dwc3-omap to receive connect and disconnect notification using
>> extcon framework. Also did the necessary cleanups required after
>> adapting to extcon framework.
>>
>> Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
>> Acked-by: Chanwoo Choi <cw00.choi@samsung.com>
>> ---
>> Changes from v1:
>> * regulator enable/disable is now done here instead of palmas-usb as some users
>> of palmas-usb wont need regulator.
>>   drivers/usb/dwc3/dwc3-omap.c  | 103 ++++++++++++++++++++++++++++++++++--------
>>   include/linux/usb/dwc3-omap.h |  30 ------------
>>   2 files changed, 85 insertions(+), 48 deletions(-)
>>   delete mode 100644 include/linux/usb/dwc3-omap.h
> I think that usb or other maintainer have to confirm this patch
> for applying extcon-next branch.

Ok. I'll check with Felipe.

Thanks
Kishon
