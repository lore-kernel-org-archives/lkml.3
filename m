Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161175Ab3DFWGX (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Apr 2013 18:06:23 -0400
Received: from server.prisktech.co.nz ([115.188.14.127]:63481 "EHLO
	server.prisktech.co.nz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161138Ab3DFWGW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Apr 2013 18:06:22 -0400
Message-ID: <51609C81.5030207@prisktech.co.nz>
Date: Sun, 07 Apr 2013 10:06:57 +1200
From: Tony Prisk <linux@prisktech.co.nz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: Thierry Reding <thierry.reding@avionic-design.de>
CC: Mark Brown <broonie@opensource.wolfsonmicro.com>,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        akpm@linux-foundation.org
Subject: Re: PWM backlight build warning
References: <51606A7F.3050803@prisktech.co.nz> <20130406200251.GO6597@opensource.wolfsonmicro.com> <20130406211041.GA15987@avionic-0098.mockup.avionic-design.de>
In-Reply-To: <20130406211041.GA15987@avionic-0098.mockup.avionic-design.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/04/13 09:10, Thierry Reding wrote:
> On Sat, Apr 06, 2013 at 09:02:51PM +0100, Mark Brown wrote:
>> On Sun, Apr 07, 2013 at 06:33:35AM +1200, Tony Prisk wrote:
>>
>>> The problem occurs because when CONFIG_PM=y but CONFIG_PM_SLEEP=n:
>>> I guess this would be a problem on every driver that has been
>>> converted to SIMPLE_DEV_PM_OPS.
>>> I don't know enough about the PM code to offer a fix, or whethermy
>>> chosen config is just 'invalid'.
>> You just need to put the system suspend functions inside an ifdef
>> CONFIG_PM_SLEEP instead of CONFIG_PM.
> I carry a fix for that in my for-next branch.
>
> Thierry
Ahh ok, all is good then.

Regards
Tony P
