Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756571AbaAJOke (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 Jan 2014 09:40:34 -0500
Received: from mail-pd0-f178.google.com ([209.85.192.178]:42045 "EHLO
	mail-pd0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751790AbaAJOkb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 Jan 2014 09:40:31 -0500
Message-ID: <52D0065B.4060905@gmail.com>
Date: Fri, 10 Jan 2014 06:40:27 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        David Laight <David.Laight@ACULAB.COM>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
References: <20140109235045.GA17660@xanatos>
In-Reply-To: <20140109235045.GA17660@xanatos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 03:50 PM, Sarah Sharp wrote:

>>> On Tue, Jan 07, 2014 at 03:57:00PM -0800, walt wrote:
>>
>> The aftermarket usb3 adapter card and the usb3 outboard hard-drive docking
>> station are the only two usb3 devices I have.
>>
>> I've wondered if my xhci problems might be caused by hardware quirks, and
>> wondering why I seem to be the only one who has this problem.
>>
>> Maybe I could "take one for the team" by buying new hardware toys that I
>> don't really need but I could use to test the xhci driver?  (I do enjoy
>> buying new toys, necessary, or, um, maybe not :)
> 
> It would be appreciated if you could see if your device causes other
> host controllers to fail.  Who am I to keep a geek from new toys? ;)

Thanks :)  Just to clarify, when you say 'your device' do you mean the
outboard disk docking station?  So I need to buy other host controllers,
not new docking stations?

> 
> In the meantime, try this patch, which is something of a long shot.

No difference.  But I notice the code enables the TRB quirk only if the
xhci_version is specifically 0x95.  My debug messages claim that "xHCI
doesn't need link TRB QUIRK" so I'm wondering if adding my asmedia device
to the quirks list really doesn't change anything unless it's xhci 0.95.

Does lspci provide that information?  I'm not seeing anything obvious.


