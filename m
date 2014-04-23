Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756122AbaDWNqH (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 09:46:07 -0400
Received: from mail-la0-f45.google.com ([209.85.215.45]:32815 "EHLO
	mail-la0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757173AbaDWNpy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 09:45:54 -0400
Message-ID: <5357C40E.7060000@cogentembedded.com>
Date: Wed, 23 Apr 2014 17:45:50 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: "Ivan T. Ivanov" <iivanov@mm-sol.com>
CC: Felipe Balbi <balbi@ti.com>, Tim Bird <tbird20d@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, Tim Bird <tim.bird@sonymobile.com>
Subject: Re: [PATCH v6 15/19] usb: phy: msm: Fix PTS definitions for MSM USB
 controller
References: <1398158438-21579-1-git-send-email-iivanov@mm-sol.com>	 <1398158438-21579-16-git-send-email-iivanov@mm-sol.com>	 <53566A23.8010508@cogentembedded.com>	 <1398259477.4724.218.camel@iivanov-dev> <1398260102.4724.223.camel@iivanov-dev>
In-Reply-To: <1398260102.4724.223.camel@iivanov-dev>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 23-04-2014 17:35, Ivan T. Ivanov wrote:

>>>> --- a/include/linux/usb/msm_hsusb_hw.h
>>>> +++ b/include/linux/usb/msm_hsusb_hw.h
>>>> @@ -31,8 +31,9 @@
>>>>    #define USB_USBINTR          (MSM_USB_BASE + 0x0148)
>>>>
>>>>    #define PORTSC_PHCD            (1 << 23) /* phy suspend mode */
>>>> -#define PORTSC_PTS_MASK         (3 << 30)
>>>> -#define PORTSC_PTS_ULPI         (3 << 30)
>>>> +#define PORTSC_PTS_MASK        (3 << 30)
>>>> +#define PORTSC_PTS_ULPI        (2 << 30)
>>>> +#define PORTSC_PTS_SERIAL      (3 << 30)

>>>      Please use tabs, not spaces here.

>> Thanks, will fix and resend.

> I answered too quickly. File contain tabs and spaces for
> indentation of definitions.

    You mean tabs and spaces on one line? Or sometimes tabs, sometimes spaces?

> Should I still use tabs here?

    If they are already used, why not?

> Regards,
> Ivan

WBR, Sergei

