Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752868AbaFJPQ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:16:59 -0400
Received: from mail.active-venture.com ([67.228.131.205]:58773 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752841AbaFJPQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:16:58 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53972163.6080905@roeck-us.net>
Date: Tue, 10 Jun 2014 08:16:51 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/40] 3.10.43-stable review
References: <20140609224839.127615063@linuxfoundation.org>
In-Reply-To: <20140609224839.127615063@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 03:48 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.43 release.
> There are 40 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jun 11 22:48:25 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
     total: 143 pass: 136 skipped: 6 fail: 1

Qemu tests all passed.

Results are as expected.
Details are available at http://server.roeck-us.net:8010/builders.

Guenter

