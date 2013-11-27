Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755148Ab3K0EOF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 23:14:05 -0500
Received: from mail.active-venture.com ([67.228.131.205]:58511 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752755Ab3K0EOD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 23:14:03 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <52957189.4050400@roeck-us.net>
Date: Tue, 26 Nov 2013 20:14:01 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
CC: torvalds@linux-foundation.org, akpm@linux-foundation.org,
        stable@vger.kernel.org
Subject: Re: [PATCH 3.4 00/39] 3.4.71-stable review
References: <20131127005619.011763867@linuxfoundation.org>
In-Reply-To: <20131127005619.011763867@linuxfoundation.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/26/2013 04:56 PM, Greg Kroah-Hartman wrote:
> This is the start of the stable review cycle for the 3.4.71 release.
> There are 39 patches in this series, all will be posted as a response
> to this one.  If anyone has any issues with these being applied, please
> let me know.
>
> Responses should be made by Fri Nov 29 00:56:06 UTC 2013.
> Anything received after that time might be too late.
>
Build results:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests all passed.

Results match the results seen previously and are as expected.

Guenter



