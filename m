Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752363Ab3JVIzT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 04:55:19 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:56381 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751126Ab3JVIzR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 04:55:17 -0400
Message-ID: <52663D6D.5000806@gmail.com>
Date: Tue, 22 Oct 2013 16:55:09 +0800
From: Mark Zhang <nvmarkzhang@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@gmail.com>
CC: rpurdie@rpsys.net, jg1.han@samsung.com,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        tomi.valkeinen@ti.com, linux-pwm@vger.kernel.org,
        "linux-fbdev@vger.kernel.org" <linux-fbdev@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: How to set fops in "struct platform_pwm_backlight_data"?
References: <525F8895.5010806@gmail.com> <20131017071445.GA2502@ulmo.nvidia.com> <5260BD8C.7000200@gmail.com> <20131022072443.GB8681@ulmo.nvidia.com>
In-Reply-To: <20131022072443.GB8681@ulmo.nvidia.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/22/2013 03:24 PM, Thierry Reding wrote:
> On Fri, Oct 18, 2013 at 12:48:12PM +0800, Mark Zhang wrote:
[...]
>>>
>>
>> Okay, I just want to set the "notify" function pointer in "struct
>> platform_pwm_backlight_data", because I want to tune the brightness
>> value before the pwm-bl sets the brightness to hardware. I don't know
>> how to do that, unless we define the platform data explicitly.
> 
> Okay, my question should have been what you need the functions for and
> why you think you need them.
> 

If I understanding you correctly, I suppose I've said that: "because I
want to tune the brightness value before the pwm-bl sets the brightness
to hardware".

Mark
> Thierry
> 
