Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752247Ab3KQVVg (ORCPT <rfc822;w@1wt.eu>);
	Sun, 17 Nov 2013 16:21:36 -0500
Received: from mail.active-venture.com ([67.228.131.205]:65162 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751292Ab3KQVV3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 17 Nov 2013 16:21:29 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52893358.3080404@roeck-us.net>
Date: Sun, 17 Nov 2013 13:21:28 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Wim Van Sebroeck <wim@iguana.be>
CC: linux-watchdog@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v4] watchdog: w83627hf: Convert to watchdog infrastructure
References: <1376773126-2717-1-git-send-email-linux@roeck-us.net> <1376773126-2717-2-git-send-email-linux@roeck-us.net> <20131028215755.GA13226@spo001.leaseweb.com> <20131029024357.GA27070@roeck-us.net> <20131117191252.GA20636@spo001.leaseweb.com>
In-Reply-To: <20131117191252.GA20636@spo001.leaseweb.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/17/2013 11:12 AM, Wim Van Sebroeck wrote:
> Hi Guenter,
>
>> Signed-off-by: Guenter Roeck <linux@roeck-us.net>
>> ---
>> v4: Restore 'nowayout' module parameter
>>
>> The changes cause a trivial conflict with 'watchdog: w83627hf: Auto-detect
>> IO address and supported chips'. Please let me know if I should re-send
>> the entire series.
>>

[ ... ]

>
> I will add this patch with above two small corrections to linux-watchdog-next.
>

Hi Wim,

still learning watchdog details ;-).

Thanks a lot for picking this up!

Guenter

