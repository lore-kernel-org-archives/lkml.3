Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752107Ab3KTExv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:53:51 -0500
Received: from mail.active-venture.com ([67.228.131.205]:53700 "EHLO
	mail.active-venture.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751301Ab3KTExt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:53:49 -0500
X-Originating-IP: 108.223.40.66
Message-ID: <528C405B.3020705@roeck-us.net>
Date: Tue, 19 Nov 2013 20:53:47 -0800
From: Guenter Roeck <linux@roeck-us.net>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
CC: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Ben Hutchings <ben@decadent.org.uk>,
        "David S. Miller" <davem@davemloft.net>
Subject: Re: [PATCH 3.4 01/12] cxgb3: Fix length calculation in write_ofld_wr()
 on 32-bit architectures
References: <20131118184130.257996039@linuxfoundation.org> <20131118184130.528352245@linuxfoundation.org> <20131119105000.GA3943@hercules.my.domain> <20131119230910.GA13667@kroah.com>
In-Reply-To: <20131119230910.GA13667@kroah.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11/19/2013 03:09 PM, Greg Kroah-Hartman wrote:
> On Tue, Nov 19, 2013 at 10:50:00AM +0000, Luis Henriques wrote:
>> Hi Greg,
>>
>> On Mon, Nov 18, 2013 at 10:41:34AM -0800, Greg Kroah-Hartman wrote:
>>> 3.4-stable review patch.  If anyone has any objections, please let me know.
>>>
>>
>> I guess you can drop this commit because, as Ben has already pointed
>> out, it is required for kernels >= 3.11.
>
> Good point, now dropped, thanks.
>

No negative impact on builds:
	total: 103 pass: 89 skipped: 10 fail: 4

qemu tests still pass.

Guenter

