Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751694AbaCaV6E (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 17:58:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:64957 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751405AbaCaV6C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 17:58:02 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5339E4E7.5080200@roeck-us.net>
Date: Mon, 31 Mar 2014 14:57:59 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Ben Hutchings <ben@decadent.org.uk>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        torvalds@linux-foundation.org,
        Satoru Takeuchi <satoru.takeuchi@gmail.com>, akpm@linux-foundation.org
Subject: Re: [PATCH 3.2 000/200] 3.2.56-rc1 review
References: <lsq.1396221814.369444335@decadent.org.uk>	 <20140331004857.GA10898@roeck-us.net> <1396227882.1241.36.camel@deadeye.wl.decadent.org.uk>
In-Reply-To: <1396227882.1241.36.camel@deadeye.wl.decadent.org.uk>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/30/2014 06:04 PM, Ben Hutchings wrote:
> On Sun, 2014-03-30 at 17:49 -0700, Guenter Roeck wrote:
>> On Mon, Mar 31, 2014 at 12:23:34AM +0100, Ben Hutchings wrote:
>>> This is the start of the stable review cycle for the 3.2.56 release.
>>> There are 200 patches in this series, which will be posted as responses
>>> to this one.  If anyone has any issues with these being applied, please
>>> let me know.
>>>
>>> Responses should be made by Wed Apr 02 00:00:00 UTC 2014.
>>> Anything received after that time might be too late.
>>>
>> Build results:
>> 	total: 116 pass: 87 skipped: 22 fail: 7
>>
>> Qemu tests all passed. Results are as expected.
>>
>> Details are available at http://server.roeck-us.net:8010/builders.
>

My pleasure.

Just for completeness ... everything still builds after you dropped a patch.
qemu tests are also still ok.

Guenter

