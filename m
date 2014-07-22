Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753961AbaGVJC0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 05:02:26 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:47621 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753923AbaGVJCX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 05:02:23 -0400
Message-ID: <53CE289B.5000908@suse.cz>
Date: Tue, 22 Jul 2014 11:02:19 +0200
From: Jiri Slaby <jslaby@suse.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Satoru Takeuchi <satoru.takeuchi@gmail.com>,
        Guenter Roeck <linux@roeck-us.net>
CC: stable@vger.kernel.org, shuah.kh@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/170] 3.12.25-stable review
References: <cover.1405685481.git.jslaby@suse.cz>	<53C9101B.6020006@suse.cz>	<53C92574.3020101@roeck-us.net> <87k37aqdi0.wl%satoru.takeuchi@gmail.com>
In-Reply-To: <87k37aqdi0.wl%satoru.takeuchi@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/19/2014 04:38 AM, Satoru Takeuchi wrote:
> At Fri, 18 Jul 2014 06:47:32 -0700,
> Guenter Roeck wrote:
>>
>> On 07/18/2014 05:16 AM, Jiri Slaby wrote:
>>> On 07/18/2014 02:12 PM, Jiri Slaby wrote:
>>>> This is the start of the stable review cycle for the 3.12.25 release.
>>>> There are 170 patches in this series, all will be posted as a response
>>>> to this one.  If anyone has any issues with these being applied, please
>>>> let me know.
>>>>
>>>> Responses should be made by Sun Jul 20 12:11:21 2014
>>>
>>> Oh, this should have been two *workdays*, i.e. the deadline is Jul 22.
>>>
>>
>> Build results:
>> 	total: 137 pass: 137 fail: 0
>>
>> Qemu tests all passed.
>>
>> Details are available at http://server.roeck-us.net:8010/builders.
>>
>> Guenter
>>
> 
> Plus, it passed my test too.

On 07/21/2014 05:31 PM, Shuah Khan wrote:
> Compiled and booted on my test system. No dmesg regressions.

Thank you all!

-- 
js
suse labs
