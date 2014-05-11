Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758116AbaEKWub (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 May 2014 18:50:31 -0400
Received: from mail.active-venture.com ([67.228.131.205]:52631 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753644AbaEKWu0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 May 2014 18:50:26 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <536FFEAA.3050409@roeck-us.net>
Date: Sun, 11 May 2014 15:50:18 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/48] 3.10.40-stable review
References: <20140511191948.079900414@linuxfoundation.org>
In-Reply-To: <20140511191948.079900414@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/11/2014 12:19 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.40 release.
> There are 48 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue May 13 19:19:30 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 127 pass: 122 skipped: 4 fail: 1

Qemu tests all passed.

Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter


