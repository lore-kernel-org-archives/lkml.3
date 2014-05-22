Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751577AbaEVFg6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 01:36:58 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52070 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEVFg5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 01:36:57 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <537D8CED.4000603@roeck-us.net>
Date: Wed, 21 May 2014 22:36:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Flavio Leitner <fbl@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>,
        Flavio Leitner <fbl@sysclose.org>
Subject: Re: [PATCH] i8k: increase fan limit to 3
References: <1400725168-21358-1-git-send-email-fbl@redhat.com> <537D6FC8.5000105@roeck-us.net> <20140522034530.GD12759@t520.home>
In-Reply-To: <20140522034530.GD12759@t520.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/21/2014 08:45 PM, Flavio Leitner wrote:
> On Wed, May 21, 2014 at 08:32:24PM -0700, Guenter Roeck wrote:
>> On 05/21/2014 07:19 PM, Flavio Leitner wrote:
>>> From: Flavio Leitner <fbl@sysclose.org>
>>>
>>> It is possible to increase left fan speed on a
>>> DELL Precision 490n system up to 3.
>>>
>>>      value    fan rpm
>>>        1      35460
>>>        2      64740
>>>        3      78510
>>>
>> Guess the speed factor 30 doesn't apply here.
>
> Those are actual rpms, not just a multiplied rpm. What I mean
> is that you can hear the fan spinning up or down and the
> temperature going up or down accordingly.
>
I don't think there are any fans running at 78k rpm. The real speed
is 78,510 / 30 or 2,617 rpm. You should set the fan_mult module
parameter to 1 for your system.

> But even setting it to 3 is not enough to spin at maximum
> speed. Anyway, now I can load the system without the FBDIMM
> going above 75oC.
>
Did you try to set higher values ?

Guenter

