Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759483Ab3E2GGt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 29 May 2013 02:06:49 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:34394 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753320Ab3E2GGr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 29 May 2013 02:06:47 -0400
Message-ID: <51A59AC9.9000908@ti.com>
Date: Wed, 29 May 2013 11:36:01 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>,
        <ldewangan@nvidia.com>, <gg@slimlogic.co.uk>, <lgirdwood@gmail.com>,
        <broonie@kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-usb@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gregkh@linuxfoundation.org>,
        <george.cherian@ti.com>, <sameo@linux.intel.com>
Subject: Re: [PATCH 0/3] palmas usb driver
References: <1369405896-30246-1-git-send-email-kishon@ti.com> <20130528173554.GD15794@arwen.pp.htv.fi>
In-Reply-To: <20130528173554.GD15794@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,

On Tuesday 28 May 2013 11:05 PM, Felipe Balbi wrote:
> On Fri, May 24, 2013 at 08:01:33PM +0530, Kishon Vijay Abraham I wrote:
>> This patch series adds driver for palmas usb which is used to detect
>> attach/detach events of usb device and usb host.
>>
>> [PATCH v5 2/3] extcon: Palmas Extcon Driver which was sent previously
>> is added in this patch series itself. The revision history is added
>> in the patch comments section.
>>
>> A checkpatch warning "WARNING: static const char * array should
>> probably be static const char * const"is ignored since it introduces a
>> compilation warning.
>>
>> Graeme Gregory (2):
>>    drivers: regulator: palmas: add an API to set/clear the switch bit on
>>      SMPS10
>>    extcon: Palmas Extcon Driver
>>
>> Kishon Vijay Abraham I (1):
>>    usb: dwc3: use extcon fwrk to receive connect/disconnect notification
>
>
> There were some comments to this series, what will happen with it ? Any
> new versions coming ?

I've already sent new versions. Palmas Extcon Driver is already queued 
in extcon-next.
Chanwoo can take this patch in his tree after your ACK. [PATCH v2] usb: 
dwc3: use extcon fwrk to receive connect/disconnect notification.

Thanks
Kishon
