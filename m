Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932540Ab3CTPWr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Mar 2013 11:22:47 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:45566 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751370Ab3CTPWq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Mar 2013 11:22:46 -0400
Message-ID: <5149D43C.3060506@ti.com>
Date: Wed, 20 Mar 2013 20:52:36 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH 0/5] usb: musb/otg: cleanup and fixes
References: <1363164430-19118-1-git-send-email-kishon@ti.com> <20130320131240.GA15157@arwen.pp.htv.fi>
In-Reply-To: <20130320131240.GA15157@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Felipe,

On Wednesday 20 March 2013 06:42 PM, Felipe Balbi wrote:
> On Wed, Mar 13, 2013 at 02:17:05PM +0530, Kishon Vijay Abraham I wrote:
>> This series has some misc cleanup and fixes. The fix solves the cold
>> plug issue in omap3 which some have reported. Developed these patches on
>> Linux 3.9-rc2 after applying http://www.spinics.net/lists/linux-usb/msg81563.html
>> (Grazvydas Ignotas patch series)
>>
>> Tested for g_zero enumeration in pandaboard and beagleboard in both
>> cold plug and hot plug case. Any kind of testing for this series is welcome.
>>
>> Kishon Vijay Abraham I (5):
>>    usb: musb: omap: remove the check before calling otg_set_vbus
>>    usb: musb: omap: always glue have the correct vbus/id status
>>    usb: otg: twl4030: use devres API for regulator get and request irq
>>    usb: musb: omap: add usb_phy_init in omap2430_musb_init
>>    usb: otg: twl4030: fix cold plug on OMAP3
>>
>>   drivers/usb/musb/omap2430.c   |   22 ++++++++++------------
>>   drivers/usb/otg/twl4030-usb.c |   35 ++++++++++++-----------------------
>>   2 files changed, 22 insertions(+), 35 deletions(-)
>
> this needs to be rebased against my 'next' branch.

The v2 of this series is already in your testing branch. You still want 
it to be rebased to your 'next' branch?

Thanks
Kishon
