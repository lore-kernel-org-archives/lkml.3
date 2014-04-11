Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755338AbaDKVqE (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 17:46:04 -0400
Received: from mail.active-venture.com ([67.228.131.205]:63518 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754300AbaDKVqC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 17:46:02 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53486293.9010602@roeck-us.net>
Date: Fri, 11 Apr 2014 14:45:55 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.13 00/65] 3.13.10-stable review
References: <20140411160957.714773410@linuxfoundation.org>
In-Reply-To: <20140411160957.714773410@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/11/2014 09:10 AM, Greg Kroah-Hartman wrote:
> ------------------------
> NOTE
>
> This is probably going to be the last 3.13.y kernel release.  There
> _might_ be one more after this, but given my travel schedule for the
> next few weeks, don't count on it.  Please move to the 3.14 kernel tree
> as soon as possible.
>
> ------------------------
>
> This is the start of the stable review cycle for the 3.13.10 release.
> There are 65 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Apr 13 16:09:42 UTC 2014.
> Anything received after that time might be too late.
>
Build results:
	total: 126 pass: 122 skipped: 4 fail: 0

Qemu tests all passed. Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

