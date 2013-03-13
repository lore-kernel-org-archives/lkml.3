Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756042Ab3CMJPj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 05:15:39 -0400
Received: from mail-bk0-f50.google.com ([209.85.214.50]:42443 "EHLO
	mail-bk0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754474Ab3CMJPh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 05:15:37 -0400
MIME-Version: 1.0
In-Reply-To: <20130313091453.GE6270@arwen.pp.htv.fi>
References: <CAFp+6iGGAY=nMg03-bqHz=XuNP+1t9mQR=M53HGoqCXv=t+f0Q@mail.gmail.com>
	<1362230724-21017-1-git-send-email-gautam.vivek@samsung.com>
	<CAFp+6iFjiOPbZhdpWCq0agWBeSC+Vc19Ff++_3vxa6r-MburWg@mail.gmail.com>
	<20130313091453.GE6270@arwen.pp.htv.fi>
Date: Wed, 13 Mar 2013 14:45:35 +0530
Message-ID: <CAFp+6iHs6U9YRLn5-x4JwAyzF4rbfQYnBT1i0oCk-Lw6K2dkLQ@mail.gmail.com>
Subject: Re: [PATCH] usb: dwc3: Set DWC3 context's mode based on selected mode.
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        gregkh@linuxfoundation.org, Vivek Gautam <gautam.vivek@samsung.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 13, 2013 at 2:44 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Wed, Mar 13, 2013 at 02:42:22PM +0530, Vivek Gautam wrote:
>> Hi Balbi,
>>
>>
>> On Sat, Mar 2, 2013 at 6:55 PM, Vivek Gautam <gautam.vivek@samsung.com> wrote:
>> > Now that machines may select the mode of working of DWC3 (HOST only,
>> > GADGET only or DUAL_ROLE), lets set DWC3 mode based on that
>> > rather than fixing it to whatever DWC3 hardware says.
>> > This way we can skip initializing Gadget/Host in case
>> > we are using Host-only/Gadget-only mode respectively.
>> >
>>
>> Hope this patch if fine, and mainlinable ?
>
> yes, it's in my testing branch, you will receive mail soon
>

Sure, thanks.

> --
> balbi



-- 
Thanks & Regards
Vivek
