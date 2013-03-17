Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752678Ab3CQABc (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Mar 2013 20:01:32 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:34380 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751853Ab3CQABb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Mar 2013 20:01:31 -0400
Message-ID: <5145095D.3010304@gmail.com>
Date: Sun, 17 Mar 2013 11:07:57 +1100
From: Ryan Mallon <rmallon@gmail.com>
User-Agent: Mozilla/5.0 (X11; U; Linux i686; en-US; rv:1.9.2.28) Gecko/20120313 Thunderbird/3.1.20
MIME-Version: 1.0
To: Arnd Bergmann <arnd@arndb.de>
CC: H Hartley Sweeten <hartleys@visionengravers.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        gregkh@linuxfoundation.org
Subject: Re: [PATCH 3/3] misc: ep93xx_pwm.c: fix section mismatch and use
 module_platform_driver
References: <201303151807.14074.hartleys@visionengravers.com> <201303161457.24825.arnd@arndb.de>
In-Reply-To: <201303161457.24825.arnd@arndb.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 17/03/13 01:57, Arnd Bergmann wrote:

> On Saturday 16 March 2013, H Hartley Sweeten wrote:
>> Remove the __init tags from the ep93xx_pwm_probe() and
>> ep93xx_pwm_remove() functions to fix the section mismatch
>> warnings.
>>
>> Use module_platform_driver() to remove the init/exit boilerplate.
>>
>> Signed-off-by: H Hartley Sweeten <hsweeten@visionengravers.com>
>> Cc: Ryan Mallon <rmallon@gmail.com>
>> Cc: Arnd Bergmann <arnd@arndb.de>
>> Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> Acked-by: Arnd Bergmann <arnd@arndb.de>


For the whole series:

Acked-by: Ryan Mallon <rmallon@gmail.com>

Not sure if I should take these in my tree, or if they should be
handled by the respective subsystem maintainers. Arnd?

~Ryan

