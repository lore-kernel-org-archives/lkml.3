Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751619Ab3FXOGq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 10:06:46 -0400
Received: from relay1.mentorg.com ([192.94.38.131]:45162 "EHLO
	relay1.mentorg.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750900Ab3FXOGp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 10:06:45 -0400
Message-ID: <51C85272.4040902@mentor.com>
Date: Mon, 24 Jun 2013 15:06:42 +0100
From: Dean Jenkins <Dean_Jenkins@mentor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130523 Thunderbird/17.0.6
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: SLIP: Is there a maintainer for drivers/net/slip/slip.c ?
References: <51C802DA.4080202@mentor.com> <51C84F76.5030402@hurleysoftware.com>
In-Reply-To: <51C84F76.5030402@hurleysoftware.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 24 Jun 2013 14:06:43.0441 (UTC) FILETIME=[0E426610:01CE70E4]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Peter,

On 24/06/13 14:53, Peter Hurley wrote:
> On 06/24/2013 04:27 AM, Dean Jenkins wrote:
>> Hi,
>>
>> Using the Linux v3.9 tag, I note that
>>
>> ./scripts/get_maintainer.pl -f drivers/net/slip/slip.c
>> netdev@vger.kernel.org (open list:NETWORKING DRIVERS)
>> linux-kernel@vger.kernel.org (open list)
>>
>> There seems to be no maintainer for drivers/net/slip/slip.c, is that 
>> true ?
>>
>> I am asking because sl_encaps() and slip_write_wakeup() do not handle 
>> error codes from tty->ops->write() and a recursive stack overflow 
>> crash can occur if the tty->ops->write() fails to write all the 
>> characters. I have some patches to fix this but would like some 
>> feedback on an appropriate solution.
>
> SLIP changes would likely go through David Miller <davem@davemloft.net>.
> TTY changes would go through Greg Kroah-Hartman 
> <gregkh@linuxfoundation.org>
I have already sent an E-mail to David Miller and the netdev mailing 
list but so far got not reply from David.

So I guess I have sent my patches to the correct place ;)

Thanks,

Regards,
Dean Jenkins
Mentor Graphics
