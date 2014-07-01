Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757957AbaGAJim (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 05:38:42 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47224 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757930AbaGAJik (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 05:38:40 -0400
Message-ID: <53B2818F.8060705@redhat.com>
Date: Tue, 01 Jul 2014 11:38:23 +0200
From: Hans de Goede <hdegoede@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Lee Jones <lee.jones@linaro.org>
CC: Mark Brown <broonie@linaro.org>,
        Charles Keepax <ckeepax@opensource.wolfsonmicro.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Carlo Caione <carlo@caione.org>,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        linux-sunxi@googlegroups.com
Subject: Re: [PATCH resend v2 1/3] mfd-core: Don't register supplies from
 add_device, add register_supply_aliases()
References: <1404138369-23907-1-git-send-email-hdegoede@redhat.com> <1404138369-23907-2-git-send-email-hdegoede@redhat.com> <20140701092255.GF27971@lee--X1>
In-Reply-To: <20140701092255.GF27971@lee--X1>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 07/01/2014 11:22 AM, Lee Jones wrote:
> On Mon, 30 Jun 2014, Hans de Goede wrote:
> 
>> We cannot register supply alias in mfd_add_device before calling
>> platform_add_device because platform-dev's name must be set before registering
>> the aliases which happens from platform_add_device.
>>
>> So stop registering supply aliases from mfd_add_device, and add a
>> mfd_register_supply_aliases helper functions for the cell's plaform driver
>> probe method to use.
>>
>> Signed-off-by: Hans de Goede <hdegoede@redhat.com>
> 
> Didn't I already Ack this?

Ah yes you did, but back then I expected the series to get picked up
immediately, so I did not add the ack to my local copy of it.

Regards,

Hans
