Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751786AbaHWSKj (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 14:10:39 -0400
Received: from shards.monkeyblade.net ([149.20.54.216]:35313 "EHLO
	shards.monkeyblade.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751372AbaHWSKi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 14:10:38 -0400
Date: Sat, 23 Aug 2014 11:10:35 -0700 (PDT)
Message-Id: <20140823.111035.1932350736810442438.davem@davemloft.net>
To: linux@roeck-us.net
Cc: jslaby@suse.cz, stable@vger.kernel.org, satoru.takeuchi@gmail.com,
        shuah.kh@samsung.com, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3.12 000/104] 3.12.27-stable review
From: David Miller <davem@davemloft.net>
In-Reply-To: <53F8AFEE.2070608@roeck-us.net>
References: <20140820195436.GA22902@roeck-us.net>
	<53F5A864.5040206@suse.cz>
	<53F8AFEE.2070608@roeck-us.net>
X-Mailer: Mew version 6.5 on Emacs 24.1 / Mule 6.0 (HANACHIRUSATO)
Mime-Version: 1.0
Content-Type: Text/Plain; charset=us-ascii
Content-Transfer-Encoding: 7bit
X-Greylist: Sender succeeded SMTP AUTH, not delayed by milter-greylist-4.5.7 (shards.monkeyblade.net [149.20.54.216]); Sat, 23 Aug 2014 11:10:37 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Guenter Roeck <linux@roeck-us.net>
Date: Sat, 23 Aug 2014 08:14:54 -0700

> On 08/21/2014 01:05 AM, Jiri Slaby wrote:
>> The last three are just cosmetical in 3.12. And I do not immediately
>> see
>> in the rest, how they could improve the state. So I am going to remove
>> the add-basic-validations patch from 3.12.
>>
> 
> Build and tests now look good.

I am hugely disappointed in this.

This is why I really do all the backports for each -stable release
myself and I therefore really wish there was more thought put into
when these changes are placed into other trees.

Almost all of those sparc64 memory management fixes should not go into
anything before v3.13, because all of these fixes are in the context
of the page tables encoding PMDs using the PTE layout.

If you're just forcing changes you see go into other -stable
submissions into your tree until they compile, and just hoping that a
tester will catch any problems, you are absolutely doing it wrong and
taking a large amount of value out of the -stable releases.

Thanks.
