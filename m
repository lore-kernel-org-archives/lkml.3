Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752142AbaBUFGe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 00:06:34 -0500
Received: from mail.active-venture.com ([67.228.131.205]:52089 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaBUFGd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 00:06:33 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <5306DEB6.2020205@roeck-us.net>
Date: Thu, 20 Feb 2014 21:05:58 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/25] 3.4.82-stable review
References: <20140220234842.483343851@linuxfoundation.org>
In-Reply-To: <20140220234842.483343851@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2014 03:51 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.82 release.
> There are 25 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sat Feb 22 23:48:32 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 97 skipped: 18 fail: 4

qemu tests all passed. Results are as expected.

Details are available at http://server.roeck-us.net:8010/builders.

Guenter


