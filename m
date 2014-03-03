Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751910AbaCCQjG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 11:39:06 -0500
Received: from top.free-electrons.com ([176.31.233.9]:35800 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1750889AbaCCQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 11:39:04 -0500
Message-ID: <5314B019.9040505@free-electrons.com>
Date: Mon, 03 Mar 2014 17:38:49 +0100
From: Gregory CLEMENT <gregory.clement@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: balbi@ti.com
CC: Nicolas Ferre <nicolas.ferre@atmel.com>,
        Alexandre Belloni <alexandre.belloni@free-electrons.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-arm-kernel@lists.infradead.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, stable@vger.kernel.org
Subject: Re: [PATCH] usb: gadget: atmel_usba: Fix crashed during stopping
 when DEBUG is enabled
References: <1393598066-4016-1-git-send-email-gregory.clement@free-electrons.com> <20140303163308.GA10987@saruman.home>
In-Reply-To: <20140303163308.GA10987@saruman.home>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/03/2014 17:33, Felipe Balbi wrote:
> On Fri, Feb 28, 2014 at 03:34:01PM +0100, Gregory CLEMENT wrote:
>> The debug trace in the atmel_usba_stop function made the assumption
>> that the driver pointer passed in parameter was not NULL. Since the
>> commit "usb: gadget: udc-core: fix a regression during gadget driver
>> unbinding", it was no more always true. This lead to a kernel crash.
>>
>> This commit now use the driver pointer stored in udc which fixes this
>> issue.
>>
>> Since the commit which have triggered this issue was backported to the
>> 3.2 stable branch, then this one should also be backported to the same
>> kernel.
>>
>> Cc: stable@vger.kernel.org # v3.2+
>> Fixes: 511f3c5326ea (usb: gadget: udc-core: fix a regression during gadget driver unbinding)
> 
> this line shouldn't be here and you're missing a SoB line, can't take
> this patch, sorry.

Right, I forgot the -s option for this commit.

and you want the "Fixes" line be before the Cc: line, right?

Thanks,

Gregory



-- 
Gregory Clement, Free Electrons
Kernel, drivers, real-time and embedded Linux
development, consulting, training and support.
http://free-electrons.com
