Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757911Ab3J2BK5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 21:10:57 -0400
Received: from intranet.asianux.com ([58.214.24.6]:31011 "EHLO
	intranet.asianux.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756651Ab3J2BK4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 21:10:56 -0400
X-Spam-Score: -100.8
Message-ID: <526F0AE3.5080105@asianux.com>
Date: Tue, 29 Oct 2013 09:09:55 +0800
From: Chen Gang <gang.chen@asianux.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Vineet Gupta <vineetg76@gmail.com>
CC: Arnd Bergmann <arnd@arndb.de>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] arc: kernel: export symbol for pm_power_off in reset.c
References: <526DDEDB.4030503@asianux.com> <526E700A.7020106@synopsys.com>
In-Reply-To: <526E700A.7020106@synopsys.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/28/2013 10:09 PM, Vineet Gupta wrote:
> On 10/28/2013 09:19 AM, Chen Gang wrote:
>> Need export symbol for it, or can not pass compiling, the related error
>> with allmodconfig: 
>>
>>     MODPOST 2994 modules
>>   ERROR: "pm_power_off" [drivers/mfd/retu-mfd.ko] undefined!
>>   ERROR: "pm_power_off" [drivers/char/ipmi/ipmi_poweroff.ko] undefined!
>>
>>
>> Signed-off-by: Chen Gang <gang.chen@asianux.com>
> 
> Applied for 3.13
> 

Thanks.
-- 
Chen Gang
