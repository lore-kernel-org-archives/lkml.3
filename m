Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751318AbaIDEzh (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 00:55:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62417 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751068AbaIDEzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 00:55:35 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5407F0C4.4080707@roeck-us.net>
Date: Wed, 03 Sep 2014 21:55:32 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linuxfoundation.org, akpm@linuxfoundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.14 00/88] 3.14.18-stable review
References: <20140903220515.958924632@linuxfoundation.org> <20140903234429.GB27174@kroah.com>
In-Reply-To: <20140903234429.GB27174@kroah.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2014 04:44 PM, Greg Kroah-Hartman wrote:
> On Wed, Sep 03, 2014 at 03:04:34PM -0700, Greg Kroah-Hartman wrote:
>> This is the start of the stable review cycle for the 3.14.18 release.
>> There are 88 patches in this series, all will be posted as a response
>> to this one.  If anyone has any issues with these being applied, please
>> let me know.
>>
>> Responses should be made by Fri Sep  5 22:04:52 UTC 2014.
>> Anything received after that time might be too late.
>>
>> The whole patch series can be found in one patch at:
>> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.18-rc1.gz
>> and the diffstat can be found below.
>
> -rc2 is out to fix some issues:
> 	kernel.org/pub/linux/kernel/v3.0/stable-review/patch-3.14.18-rc2.gz
>

Build results:
	total: 137 pass: 137 fail: 0

Qemu tests all passed.

Detailed build and test results are available at
http://server.roeck-us.net:8010/builders.

On a side note, I got an error on e-mails to linux-foundation.org.
Should that have been linuxfoundation.org ?

Guenter


