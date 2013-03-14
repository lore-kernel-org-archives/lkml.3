Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757489Ab3CNOtB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 10:49:01 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:39422 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756635Ab3CNOtA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 10:49:00 -0400
Message-ID: <5141E351.1060005@ti.com>
Date: Thu, 14 Mar 2013 20:18:49 +0530
From: kishon <kishon@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: <balbi@ti.com>
CC: <gregkh@linuxfoundation.org>, <linux-usb@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <tony@atomide.com>, <notasas@gmail.com>
Subject: Re: [PATCH v2 0/4] usb: musb/otg: cleanup and fixes
References: <1363242239-1061-1-git-send-email-kishon@ti.com> <20130314133313.GB26080@arwen.pp.htv.fi> <5141E26C.10700@ti.com> <20130314144744.GM26080@arwen.pp.htv.fi>
In-Reply-To: <20130314144744.GM26080@arwen.pp.htv.fi>
Content-Type: text/plain; charset="ISO-8859-1"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 14 March 2013 08:17 PM, Felipe Balbi wrote:
> On Thu, Mar 14, 2013 at 08:15:00PM +0530, kishon wrote:
>> On Thursday 14 March 2013 07:03 PM, Felipe Balbi wrote:
>>> On Thu, Mar 14, 2013 at 11:53:55AM +0530, Kishon Vijay Abraham I wrote:
>>>> This series has some misc cleanup and fixes. The fix solves the cold
>>>> plug issue in omap3 which some have reported. Developed these patches on
>>>> fixes-for-v3.9-rc3 after applying
>>>> http://www.spinics.net/lists/linux-usb/msg81563.html
>>>> (Grazvydas Ignotas patch series)
>>>>
>>>> Tested for g_zero enumeration in pandaboard and beagleboard in both
>>>> cold plug and hot plug case. Any kind of testing for this series is welcome.
>>>>
>>>> Changes from v1:
>>>> * removed *usb: musb: omap: remove the check before calling otg_set_vbus*
>>
>> er.. removed *usb: musb: omap: always glue have the correct vbus/id
>> status* since a patch similar to it is already merged.
>
> alright, I'll apply this series soonish.
>
Ok.

Thanks
Kishon
