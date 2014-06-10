Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752648AbaFJPNh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 11:13:37 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49650 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752030AbaFJPNf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 11:13:35 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53972097.7040902@roeck-us.net>
Date: Tue, 10 Jun 2014 08:13:27 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.5.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/88] 3.4.93-stable review
References: <20140610002424.500996570@linuxfoundation.org>
In-Reply-To: <20140610002424.500996570@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/09/2014 05:24 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.93 release.
> There are 88 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Thu Jun 12 00:24:06 UTC 2014.
> Anything received after that time might be too late.
>
Build results:
	total: 136 pass: 109 skipped: 20 fail: 7

Qemu tests all passed.

Results are as expected.
Details are available at http://server.roeck-us.net:8010/builders.

Guenter


