Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754898Ab3DWExO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 00:53:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:49045 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754802Ab3DWExM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 00:53:12 -0400
Message-ID: <517613AF.7060305@ti.com>
Date: Tue, 23 Apr 2013 10:23:03 +0530
From: Sourav Poddar <sourav.poddar@ti.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <khilman@linaro.org>,
        <linux-serial@vger.kernel.org>, <linux-omap@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Benoit Cousson <b-cousson@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Rajendra nayak <rnayak@ti.com>
Subject: Re: [PATCHv2 4/5] arm: dts: am33xx: Remove "ti,no_idle_on_suspend"
 property.
References: <1366638237-6880-1-git-send-email-sourav.poddar@ti.com> <1366638237-6880-5-git-send-email-sourav.poddar@ti.com> <20130422143537.GD7508@arwen.pp.htv.fi>
In-Reply-To: <20130422143537.GD7508@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Felipe,
On Monday 22 April 2013 08:05 PM, Felipe Balbi wrote:
> Hi,
>
> On Mon, Apr 22, 2013 at 07:13:56PM +0530, Sourav Poddar wrote:
>> The "ti,no_idle_on_suspend" property was required to keep ocmcram
>> clocks running during idle.
>>
>> But the commit below[1], added in v3.6 should prevent the
>> any automaic clock gating for devices without drivers bound.  Since
>> there is no driver for the OCM RAM block, we are not affected by
>> the automatic idle on suspend anyways.
>> [1]:
>> commit 72bb6f9b51c82c820ddef892455a85b115460904
> your commit log can be improved a bit, it could look like below:
>
> The "ti,no_idle_on_suspend" property was required to keep ocmcram clocks
> running during idle.
>
> But commit 72bb6f9 (ARM: OMAP: omap_device: don't attempt late suspend
> if no driver bound), added in v3.6 should prevent any automatic clock
> gating for devices without drivers bound.  Since there is no driver for
> the OCM RAM block, we are not affected by the automatic idle on suspend
> anyways which means "ti,no_idle_on_suspend" can be safely removed since
> there are no users for it.
>
Looks better. Will make the necesary change in the next version.
> other than that:
>
> Reviewed-by: Felipe Balbi<balbi@ti.com>
>

