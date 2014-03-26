Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755096AbaCZOms (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 10:42:48 -0400
Received: from bear.ext.ti.com ([192.94.94.41]:50205 "EHLO bear.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751232AbaCZOmq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 10:42:46 -0400
Message-ID: <5332E759.20007@ti.com>
Date: Wed, 26 Mar 2014 16:42:33 +0200
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>, <balbi@ti.com>
CC: <linux-usb@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        "3.9+" <stable@vger.kernel.org>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: Re: [PATCH] usb: gadget: zero: Fix SuperSpeed enumeration for alternate
 setting 1
References: <1395826086-5097-1-git-send-email-rogerq@ti.com> <5332D0C8.5040300@cogentembedded.com>
In-Reply-To: <5332D0C8.5040300@cogentembedded.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/26/2014 03:06 PM, Sergei Shtylyov wrote:
> Hello.
> 
> On 26-03-2014 13:28, Roger Quadros wrote:
> 
>> It was impossible to enumerate on a SuperSpeed (XHCI) host
>> with alternate setting = 1 due to the wrongly set 'bMaxBurst'
>> field in the SuperSpeed Endpoint Companion descriptor.
> 
>> Testcase:
>> <host> modprobe -r usbtest; modprobe usbtest alt=1
>> <device> modprobe g_zero
>> plug device to SuperSpeed port on the host.
> 
>> Without this patch the host always complains like so
>> "usb 12-2: Not enough bandwidth for new device state.
>>   usb 12-2: Not enough bandwidth for altsetting 1"
> 
>> Bug was introduced by commit cf9a08ae in v3.9
> 
>    Please also specify that commit's summary in parens. Also, there's now an adopted standard way of saying this:
> 
> Fixes: <12-digit SHA ID> ("<summary line>")
> 
Right. will send a v2. Thanks.

cheers,
-roger
