Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752150AbaF1WaN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 18:30:13 -0400
Received: from mail.active-venture.com ([67.228.131.205]:62548 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751464AbaF1WaK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 18:30:10 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53AF41EE.9020901@roeck-us.net>
Date: Sat, 28 Jun 2014 15:30:06 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 00/77] 3.10.46-stable review
References: <20140628174521.691276402@linuxfoundation.org>
In-Reply-To: <20140628174521.691276402@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/28/2014 10:45 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.46 release.
> There are 77 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Mon Jun 30 17:45:02 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 144 pass: 136 skipped: 6 fail: 2
Failed builds:
	score:defconfig
	unicore32:defconfig

Qemu tests all passed

Results are as expected. Details are available at http://server.roeck-us.net:8010/builders.

Guenter

