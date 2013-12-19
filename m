Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752255Ab3LSCCu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 21:02:50 -0500
Received: from mail.active-venture.com ([67.228.131.205]:54591 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751231Ab3LSCCs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 21:02:48 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52B253C5.3030201@roeck-us.net>
Date: Wed, 18 Dec 2013 18:02:45 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/31] 3.4.75-stable review
References: <20131218210522.790152625@linuxfoundation.org>
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/18/2013 01:08 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.75 release.
> There are 31 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Dec 20 21:05:11 UTC 2013.
> Anything received after that time might be too late.
>
Build results:
     total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all passed.

Results are as expected.
Details are available as usual at http://server.roeck-us.net:8010/builders.

Guenter

