Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755494AbaCLQ2h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 12:28:37 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:21131 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753630AbaCLQ2f (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 12:28:35 -0400
Message-ID: <53208B2C.6020208@atmel.com>
Date: Wed, 12 Mar 2014 17:28:28 +0100
From: Nicolas Ferre <nicolas.ferre@atmel.com>
Organization: atmel
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-usb@vger.kernel.org>, stable <stable@vger.kernel.org>,
        <jjhiblot@traphandler.com>, <linux-kernel@vger.kernel.org>,
        <linux-arm-kernel@lists.infradead.org>, <b.brezillon@overkiz.com>
Subject: Re: [PATCH RESEND] usb: at91-udc: fix irq and iomem resource retrieval
References: <1390488102-8548-1-git-send-email-jjhiblot@traphandler.com> <1392210209-22142-1-git-send-email-nicolas.ferre@atmel.com> <532075EC.7060809@atmel.com> <20140312153140.GA8141@kroah.com>
In-Reply-To: <20140312153140.GA8141@kroah.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.161.30.18]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12/03/2014 16:31, Greg Kroah-Hartman :
> On Wed, Mar 12, 2014 at 03:57:48PM +0100, Nicolas Ferre wrote:
>> On 12/02/2014 14:03, Nicolas Ferre :
>>> From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>>>
>>> When using dt resources retrieval (interrupts and reg properties) there is
>>> no predefined order for these resources in the platform dev resource
>>> table. Also don't expect the number of resource to be always 2.
>>>
>>> Signed-off-by: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
>>> Acked-by: Boris BREZILLON <b.brezillon@overkiz.com>
>>> Acked-by: Nicolas Ferre <nicolas.ferre@atmel.com>
>>> Cc: stable <stable@vger.kernel.org> # 3.4
>>
>> Gentle ping, after having resent the patch itself.
> 
> It helps if you send it to the correct maintainer, remember,
> scripts/get_maintainer.pl is your friend...

Indeed. I add Felipe to my next attempt: sorry for the (repeated) noise.

Bye,
-- 
Nicolas Ferre
