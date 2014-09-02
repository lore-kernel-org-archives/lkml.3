Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755527AbaIBWRY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 18:17:24 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:46159 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751326AbaIBWRV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 18:17:21 -0400
Message-ID: <540641F6.1050504@ti.com>
Date: Tue, 2 Sep 2014 18:17:26 -0400
From: Murali Karicheri <m-karicheri2@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:12.0) Gecko/20120430 Thunderbird/12.0.1
MIME-Version: 1.0
To: Peter Hurley <peter@hurleysoftware.com>
CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>,
        One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>,
        <linux-serial@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Rob Herring <robh+dt@kernel.org>
Subject: Re: [PATCH 01/26] Revert "serial: uart: add hw flow control support
 configuration"
References: <1409693975-1028-1-git-send-email-peter@hurleysoftware.com> <1409693975-1028-2-git-send-email-peter@hurleysoftware.com> <54063BA1.2030206@ti.com> <54063D96.30703@hurleysoftware.com>
In-Reply-To: <54063D96.30703@hurleysoftware.com>
Content-Type: text/plain; charset="UTF-8"; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/02/2014 05:58 PM, Peter Hurley wrote:
> On 09/02/2014 05:50 PM, Murali Karicheri wrote:
>> Peter,
>>
>> On 09/02/2014 05:39 PM, Peter Hurley wrote:
>>>   Finally, this patch
>>> supposes to fix existing bugs in the serial core for auto CTS-enabled
>>> hardware, but does not include the class of hardware for which these
>>> bugs exist.
>>
>> What is this? What class of hardware are you referring to?
>
> UART_CAP_AFE and UART_CAP_EFR hardware.
>
>> As discussed, I will send an updated patch for this as discussed..
>
> Great.
>
> And since that patch will touch every single line this reverts (and more)
> with a different solution, I see no reason not to back this out.
>

No Issues and I am fine with the revert.

> Plus, as you can see, you're holding up progress.

I need to make progress on the hardware that I deal with for which this 
patch was submitted :) Unfortunately this patch didn't get proper review 
before merge causing the issue. Just want to give right context.

Regards,
Murali
>
> Regards,
> Peter Hurley
>

