Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751514AbaAGFBO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 00:01:14 -0500
Received: from mail.active-venture.com ([67.228.131.205]:63400 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750817AbaAGFBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 00:01:12 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52CB8A18.9060104@roeck-us.net>
Date: Mon, 06 Jan 2014 21:01:12 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/43] 3.4.76-stable review
References: <20140106223942.259651490@linuxfoundation.org>
In-Reply-To: <20140106223942.259651490@linuxfoundation.org>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/06/2014 02:39 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.76 release.
> There are 43 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Wed Jan  8 22:39:27 UTC 2014.
> Anything received after that time might be too late.
>

Build results:
	total: 104 pass: 89 skipped: 11 fail: 4

qemu tests all passed.

Results are as expected.
Details are available as usual at http://server.roeck-us.net:8010/builders.

Guenter

