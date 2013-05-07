Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758898Ab3EGFNY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 May 2013 01:13:24 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:44348 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758304Ab3EGFNX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 May 2013 01:13:23 -0400
Message-ID: <51888D55.3090907@ti.com>
Date: Tue, 7 May 2013 10:42:53 +0530
From: Kishon Vijay Abraham I <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Mark Brown <broonie@kernel.org>
CC: <myungjoo.ham@samsung.com>, <cw00.choi@samsung.com>, <balbi@ti.com>,
        <ldewangan@nvidia.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <grant.likely@linaro.org>, <rob.herring@calxeda.com>,
        <rob@landley.net>, <gg@slimlogic.co.uk>, <ruchika@ti.com>,
        <tony@atomide.com>, <sameo@linux.intel.com>
Subject: Re: [PATCH v4] extcon: Palmas Extcon Driver
References: <1362662506-14823-4-git-send-email-kishon@ti.com> <1367846225-15685-1-git-send-email-kishon@ti.com> <20130506144010.GF13472@opensource.wolfsonmicro.com>
In-Reply-To: <20130506144010.GF13472@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Monday 06 May 2013 08:10 PM, Mark Brown wrote:
> On Mon, May 06, 2013 at 06:47:04PM +0530, Kishon Vijay Abraham I wrote:
>
>> +		if (palmas_usb->linkstat != PALMAS_USB_STATE_VBUS) {
>> +			if (palmas_usb->vbus_reg) {
>> +				ret = regulator_enable(palmas_usb->vbus_reg);
>> +				if (ret) {
>> +					dev_dbg(palmas_usb->dev,
>> +						"regulator enable failed\n");
>> +					goto ret0;
>
> This is very bad karma, why is the regulator optional?

The platform can provide it's own vbus control in which case this is not 
needed.

Thanks
Kishon
