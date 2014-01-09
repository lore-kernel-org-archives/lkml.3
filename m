Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753290AbaAIPKx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 10:10:53 -0500
Received: from mail-pa0-f47.google.com ([209.85.220.47]:51096 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751255AbaAIPKn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 10:10:43 -0500
Message-ID: <52CEBBF0.6040603@gmail.com>
Date: Thu, 09 Jan 2014 07:10:40 -0800
From: walt <w41ter@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.1.1
MIME-Version: 1.0
To: David Laight <David.Laight@ACULAB.COM>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        "stable@vger.kernel.org" <stable@vger.kernel.org>,
        "linux-usb@vger.kernel.org" <linux-usb@vger.kernel.org>,
        "linux-scsi@vger.kernel.org" <linux-scsi@vger.kernel.org>
Subject: Re: [PATCH 3.12 033/118] usb: xhci: Link TRB must not occur within
 a USB payload burst
References: <20131218211219.461663463@linuxfoundation.org> <20131218211220.412278148@linuxfoundation.org> <52C32BB0.90600@gmail.com> <20140102191510.GA9621@xanatos> <52C6D9F1.9000709@gmail.com> <20140103195455.GA4193@xanatos> <52C729CE.9050307@gmail.com> <20140103232929.GD4193@xanatos> <52CDF9CD.8010402@gmail.com> <063D6719AE5E284EB5DD2968C1650D6D455F92@AcuExch.aculab.com>
In-Reply-To: <063D6719AE5E284EB5DD2968C1650D6D455F92@AcuExch.aculab.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/09/2014 02:05 AM, David Laight wrote:
>> From: walt
> ...
>> I'm still wondering if I'm suffering from hardware quirks.  From the
>> first day I installed my usb3 adapter card and the usb3 disk docking
>> station I've noticed some quirky behavior.
> 
> Ah - this isn't an 'on chip' usb3 adapter.
> Some kind of PCIe card ?

This one:

http://www.sabrent.com/category/controller-cards/PCIX-USB3/
 

