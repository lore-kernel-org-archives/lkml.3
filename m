Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752727AbaBUFJx (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 00:09:53 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53029 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751009AbaBUFJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 00:09:52 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5306DF9C.5050408@roeck-us.net>
Date: Thu, 20 Feb 2014 21:09:48 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/66] 3.10.32-stable review
References: <20140220234909.482516304@linuxfoundation.org>
In-Reply-To: <20140220234909.482516304@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 03:50 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.32 release.
> There are 66 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Feb 22 23:48:52 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 126 pass: 111 skipped: 4 fail: 11

qemu tests all passed. Results are not as expected. New failures are
due to

Guenter Roeck <linux@roeck-us.net>
     iio: max1363: Use devm_regulator_get_optional for optional regulator

[Oops]

Please drop this patch from 3.10; it doesn't apply to this version.

Details are at http://server.roeck-us.net:8010/builders.

Guenter

