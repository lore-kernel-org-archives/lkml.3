Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752712AbaAZFRj (ORCPT <rfc822;w@1wt.eu>);
	Sun, 26 Jan 2014 00:17:39 -0500
Received: from mail.active-venture.com ([67.228.131.205]:61073 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751008AbaAZFRh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 26 Jan 2014 00:17:37 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52E49A71.4020303@roeck-us.net>
Date: Sat, 25 Jan 2014 21:17:37 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/12] 3.4.78-stable review
References: <20140126030451.934281002@linuxfoundation.org>
In-Reply-To: <20140126030451.934281002@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/25/2014 07:05 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.78 release.
> There are 12 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Tue Jan 28 03:04:41 UTC 2014.
> Anything received after that time might be too late.
>

Build results are as expected, with the usual failures:
	total: 119 pass: 97 skipped: 18 fail: 4

qemu tests all passed.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter

