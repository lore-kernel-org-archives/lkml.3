Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751588Ab3F0BRw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Jun 2013 21:17:52 -0400
Received: from g4t0017.houston.hp.com ([15.201.24.20]:37182 "EHLO
	g4t0017.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751349Ab3F0BRv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Jun 2013 21:17:51 -0400
Message-ID: <51CB92B8.7060706@hp.com>
Date: Thu, 27 Jun 2013 09:17:44 +0800
From: "Li, Zhen-Hua (USL-China)" <zhen-hual@hp.com>
Organization: USL-China
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>, gregkh@linuxfoundation.org
CC: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] usb,uhci: add a new tag for virtual uhci devices
References: <Pine.LNX.4.44L0.1306261516280.1880-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1306261516280.1880-100000@iolanthe.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,

I don't have a machine that this makes action different.

No matter whether it makes different, there is one thing will never change:
We create a patch to FIX a problem, not to avoid a problem.
Only when we can not fix it, we try to avoid it.

Thanks
ZhenHua

On 06/27/2013 03:17 AM, Alan Stern wrote:
> On Wed, 26 Jun 2013, Li, Zhen-Hua wrote:
>
>> From: "Li, Zhen-Hua" <zhen-hual@hp.com>
>>
>> There's another patch trying to fix this warning:
>>   "Controller not stopped yet!".
>> It is : 997ff893603c6455da4c5e26ba1d0f81adfecdfc .
>>
>> I don't think it is appropriate to avoid auto-stop for all HP uhci
>> devices. So add one  tag for the virtual uhci devices, it is used
>> to replace "wait_for_hp" in the auto-stop case.
> Do you have any machines where this makes a difference?
>
> Alan Stern
>
> .
>

