Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751473AbaEWSdZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 May 2014 14:33:25 -0400
Received: from mail.active-venture.com ([67.228.131.205]:61946 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750971AbaEWSdY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 May 2014 14:33:24 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <537F9467.4020407@roeck-us.net>
Date: Fri, 23 May 2014 11:33:11 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Flavio Leitner <fbl@redhat.com>
CC: linux-kernel@vger.kernel.org, Arnd Bergmann <arnd@arndb.de>
Subject: Re: [PATCH] i8k: increase fan limit to 3
References: <1400725168-21358-1-git-send-email-fbl@redhat.com> <20140522151048.GB1001@roeck-us.net> <20140522155458.GI12759@t520.home> <20140522180023.GB14814@roeck-us.net> <20140523170904.GA2498@t520.home>
In-Reply-To: <20140523170904.GA2498@t520.home>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/23/2014 10:09 AM, Flavio Leitner wrote:
> On Thu, May 22, 2014 at 11:00:23AM -0700, Guenter Roeck wrote:
>> On Thu, May 22, 2014 at 12:54:58PM -0300, Flavio Leitner wrote:
>>> On Thu, May 22, 2014 at 08:10:48AM -0700, Guenter Roeck wrote:
>>>> On Wed, May 21, 2014 at 11:19:28PM -0300, Flavio Leitner wrote:
>>>>> From: Flavio Leitner <fbl@sysclose.org>
>>> I volunteer to test on precision 490n and on latitude D520.
>>>
>> Can you send me dmi information for those systems ?
>> The output of "grep . /sys/class/dmi/id/*" should do.
>

> /sys/class/dmi/id/chassis_vendor:Dell Inc.
> /sys/class/dmi/id/product_name:Latitude D520

What is the maximum speed value for the D520 ?

Thanks,
Guenter


