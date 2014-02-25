Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753195AbaBYJky (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Feb 2014 04:40:54 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:52158 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751545AbaBYJkv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Feb 2014 04:40:51 -0500
Message-ID: <530C6506.5050607@ti.com>
Date: Tue, 25 Feb 2014 11:40:22 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: <tony@atomide.com>, <bcousson@baylibre.com>, <balbi@ti.com>, <nm@ti.com>,
        <khilman@linaro.org>, <linux-omap@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <devicetree@vger.kernel.org>, <linux-usb@vger.kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>
Subject: Re: [PATCH v8 01/14] mfd: omap-usb-host: Get clocks based on hardware
 revision
References: <1392896409-5101-1-git-send-email-rogerq@ti.com> <1392896409-5101-2-git-send-email-rogerq@ti.com> <20140225093759.GA22755@lee--X1>
In-Reply-To: <20140225093759.GA22755@lee--X1>
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/25/2014 11:37 AM, Lee Jones wrote:
>> Not all revisions have all the clocks so get the necessary clocks
>> based on hardware revision.
>>
>> This should avoid un-necessary clk_get failure messages that were
>> observed earlier.
>>
>> CC: Lee Jones <lee.jones@linaro.org>
>> CC: Samuel Ortiz <sameo@linux.intel.com>
>> Signed-off-by: Roger Quadros <rogerq@ti.com>
>> ---
>>  drivers/mfd/omap-usb-host.c | 43 ++++++++++++++++++++++++++++++++-----------
>>  1 file changed, 32 insertions(+), 11 deletions(-)
> 
> What about patches 1 and 2. Are these safe to go in alone?
> 
patch 6 must not go in without 1. I've just asked Mike if we can squash it into 1.

patch 2 can go alone.

cheers,
-roger
