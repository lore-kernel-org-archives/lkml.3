Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757759AbaEKWtp (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 18:49:45 -0400
Received: from mail.active-venture.com ([67.228.131.205]:59392 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757363AbaEKWtl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 18:49:41 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <536FFE7E.4010000@roeck-us.net>
Date: Sun, 11 May 2014 15:49:34 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/22] 3.4.90-stable review
References: <20140511192103.733723493@linuxfoundation.org>
In-Reply-To: <20140511192103.733723493@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 12:21 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.90 release.
> There are 22 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May 13 19:20:50 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 120 pass: 97 skipped: 18 fail: 5

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

