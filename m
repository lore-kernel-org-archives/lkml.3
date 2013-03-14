Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757510Ab3CNOpO (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:45:14 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:56195 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757315Ab3CNOpK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:45:10 -0400
Message-ID: <5141E26C.10700@ti.com>
Date: Thu, 14 Mar 2013 20:15:00 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH v2 0/4] usb: musb/otg: cleanup and fixes
References: <1363242239-1061-1-git-send-email-kishon@ti.com> <20130314133313.GB26080@arwen.pp.htv.fi>
In-Reply-To: <20130314133313.GB26080@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 March 2013 07:03 PM, Felipe Balbi wrote:
> On Thu, Mar 14, 2013 at 11:53:55AM +0530, Kishon Vijay Abraham I wrote:
>> This series has some misc cleanup and fixes. The fix solves the cold
>> plug issue in omap3 which some have reported. Developed these patches on
>> fixes-for-v3.9-rc3 after applying
>> http://www.spinics.net/lists/linux-usb/msg81563.html
>> (Grazvydas Ignotas patch series)
>>
>> Tested for g_zero enumeration in pandaboard and beagleboard in both
>> cold plug and hot plug case. Any kind of testing for this series is welcome.
>>
>> Changes from v1:
>> * removed *usb: musb: omap: remove the check before calling otg_set_vbus*

er.. removed *usb: musb: omap: always glue have the correct vbus/id 
status* since a patch similar to it is already merged.
>
> it's still on your list of patches :-p
>
>> a similar patch is already merged.
>>
>> Kishon Vijay Abraham I (4):
>>    usb: musb: omap: remove the check before calling otg_set_vbus
>
> see ^^
>
> please fix it up and when resending add Grazvydas' Tested-by since he
> has tested this patchset

Ok.

Thanks
Kishon
