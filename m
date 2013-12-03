Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753197Ab3LCCux (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 21:50:53 -0500
Received: from mail.active-venture.com ([67.228.131.205]:60318 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752007Ab3LCCuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 21:50:51 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <529D4705.1000100@roeck-us.net>
Date: Mon, 02 Dec 2013 18:50:45 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/60] 3.4.72-stable review
References: <20131202190330.152596462@linuxfoundation.org>
In-Reply-To: <20131202190330.152596462@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/02/2013 11:05 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.72 release.
> There are 60 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Dec  4 19:01:45 UTC 2013.
> Anything received after that time might be too late.
>

Build results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all passed. Results are as expected.

Guenter


