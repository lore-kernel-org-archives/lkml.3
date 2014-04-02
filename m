Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756653AbaDBAB1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 20:01:27 -0400
Received: from mail.active-venture.com ([67.228.131.205]:56152 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755752AbaDBABY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 20:01:24 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <533B5351.4000002@roeck-us.net>
Date: Tue, 01 Apr 2014 17:01:21 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 0/9] 3.10.36-stable review
References: <20140401040754.479538406@linuxfoundation.org>
In-Reply-To: <20140401040754.479538406@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 09:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.36 release.
> There are 9 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Apr  3 04:07:29 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
         total: 126 pass: 122 skipped: 4 fail: 0

Qemu tests all passed. Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

