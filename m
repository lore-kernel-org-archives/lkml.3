Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965645AbaDJIbi (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 04:31:38 -0400
Received: from mail.active-venture.com ([67.228.131.205]:50975 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964832AbaDJIbf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 04:31:35 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <534656E3.8060106@roeck-us.net>
Date: Thu, 10 Apr 2014 01:31:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 000/134] 3.4.87-stable review
References: <20140410032259.587501440@linuxfoundation.org>
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/09/2014 08:21 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.87 release.
> There are 134 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Apr 12 03:22:28 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 97 skipped: 18 fail: 4

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.
Test scripts are at https://github.com/groeck/linux-build-test.

Guenter

