Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751580AbaC2BAI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 21:00:08 -0400
Received: from mail.active-venture.com ([67.228.131.205]:49296 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751364AbaC2BAG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 21:00:06 -0400
X-Originating-IP: 108.223.40.66
Message-ID: <53361B12.8010606@roeck-us.net>
Date: Fri, 28 Mar 2014 18:00:02 -0700
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        satoru.takeuchi@gmail.com, shuah.kh@samsung.com,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/13] 3.4.85-stable review
References: <20140328173053.049244535@linuxfoundation.org>
In-Reply-To: <20140328173053.049244535@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/28/2014 10:31 AM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.85 release.
> There are 13 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Sun Mar 30 17:30:36 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 119 pass: 97 skipped: 18 fail: 4

qemu tests all passed.

Results are as expected.
Details are available at http://server.roeck-us.net:8010/builders.

Guenter

