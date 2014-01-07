Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752369AbaAGFCp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:02:45 -0500
Received: from mail.active-venture.com ([67.228.131.205]:60645 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751581AbaAGFCn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:02:43 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52CB8A74.7080107@roeck-us.net>
Date: Mon, 06 Jan 2014 21:02:44 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.10 000/129] 3.10.26-stable review
References: <20140106223859.589799655@linuxfoundation.org>
In-Reply-To: <20140106223859.589799655@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 02:37 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.10.26 release.
> There are 129 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jan  8 22:38:42 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 111 pass: 109 skipped: 1 fail: 1

Build avr32:atngw100mkii_evklcd101_defconfig still fails.

qemu tests all passed.

Results are as expected.
Details are available as usual at http://server.roeck-us.net:8010/builders.

Guenter

