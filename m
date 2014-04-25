Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588AbaDYAMn (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 20:12:43 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52239 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752052AbaDYAMl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 20:12:41 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <5359A877.9020108@roeck-us.net>
Date: Thu, 24 Apr 2014 17:12:39 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/27] 3.4.88-stable review
References: <20140424215551.942390050@linuxfoundation.org>
In-Reply-To: <20140424215551.942390050@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/24/2014 02:55 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.88 release.
> There are 27 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Apr 26 21:55:41 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 97 skipped: 18 fail: 4

Qemu tests all passed. Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

