Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752355AbaANV1a (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 Jan 2014 16:27:30 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:42690 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752226AbaANV11 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 Jan 2014 16:27:27 -0500
Message-ID: <52D5ABBD.7090202@gmail.com>
Date: Tue, 14 Jan 2014 13:27:25 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: David Laight <David.Laight@ACULAB.COM>,
        Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst [NEW HARDWARE]
References: <20140109235045.GA17660@xanatos> <52D4791B.3030309@gmail.com> <20140114172056.GB12126@xanatos>
In-Reply-To: <20140114172056.GB12126@xanatos>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/14/2014 09:20 AM, Sarah Sharp wrote:
> On Mon, Jan 13, 2014 at 03:39:07PM -0800, walt wrote:

>> Sarah, I just fixed my xhci bug for US$19.99 :)
>>
>> #lspci | tail -1
>> 04:00.0 USB controller: NEC Corporation uPD720200 USB 3.0 Host Controller (rev 03)
>>
>> This new NEC usb3 controller does everything the ASMedia controller should have
>> done from the start.

 
> I just got a similar report from someone with a Fresco Logic host
> controller, so I may need you to test a work-around patch for the
> ASMedia host at some point.

Oy, Sarah! ;)  I put the ASMedia adapter in my older amd64 machine, and, well,
the stupid thing Just Works(TM) with kernel 3.12.7!  (Yes, with the same disk
docking station, too.)

I can't believe the adapter works perfectly in a different computer.  Have you
seen this kind of thing before?

At the moment I have two machines using your xhci driver and both work perfectly,
so I thank you again :)

I'm not sure where to go with this next.  I could put the adapter back in the
other machine again if you have more patches to test.


