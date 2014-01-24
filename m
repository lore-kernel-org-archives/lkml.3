Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750935AbaAXFbd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 00:31:33 -0500
Received: from mail.active-venture.com ([67.228.131.205]:64984 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750753AbaAXFba (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 00:31:30 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52E1F750.7030604@roeck-us.net>
Date: Thu, 23 Jan 2014 21:17:04 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        akpm@linux-foundation.org, stable@vger.kernel.org
Subject: Re: [PATCH 3.12 00/27] 3.12.9-stable review
References: <20140123190648.720195687@linuxfoundation.org> <20140123232030.GA31674@roeck-us.net> <20140124041135.GD25507@kroah.com>
In-Reply-To: <20140124041135.GD25507@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/23/2014 08:11 PM, Greg Kroah-Hartman wrote:
> On Thu, Jan 23, 2014 at 03:20:30PM -0800, Guenter Roeck wrote:
>> On Thu, Jan 23, 2014 at 11:06:37AM -0800, Greg Kroah-Hartman wrote:
>>> This is the start of the stable review cycle for the 3.12.9 release.
>>> There are 27 patches in this series, all will be posted as a response
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Sat Jan 25 19:06:36 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>> Build test looks good:
>> 	total: 126 pass: 121 skipped: 5 fail: 0
>>
>> Note that I added several individual build tests for arm but dropped
>> arm:allmodconfig. Background is that arm:allmodconfig is quite notoriously
>> broken nowadays, and it doesn't make much sense to keep testing it.
>
> It's broken?  I thought it had been building fine for a while now?
>

In mainline, yes. Or at least it was when I dropped it, and I gave up on it.

Guenter


