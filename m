Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758333Ab3BLIg7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 03:36:59 -0500
Received: from mho-04-ewr.mailhop.org ([204.13.248.74]:52612 "EHLO
	mho-02-ewr.mailhop.org" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1757999Ab3BLIg6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 03:36:58 -0500
X-Mail-Handler: Dyn Standard SMTP by Dyn
X-Originating-IP: 80.134.173.7
X-Report-Abuse-To: abuse@dyndns.com (see http://www.dyndns.com/services/sendlabs/outbound_abuse.html for abuse reporting information)
X-MHO-User: U2FsdGVkX18rdmjsSyznmKBCtAI525w1W/oJC+HOdr4=
Message-ID: <5119FF25.40501@googlemail.com>
Date: Tue, 12 Feb 2013 09:36:53 +0100
From: =?ISO-8859-1?Q?Holger_Hoffst=E4tte?= 
	<holger.hoffstaette@googlemail.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Jonathan Nieder <jrnieder@gmail.com>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>, stable@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org
Subject: Re: [regression] external HDD in USB3 enclosure cannot be dynamically
 removed (Re: Linux 3.7.5)
References: <20130128045658.GA3488@kroah.com> <pan.2013.01.28.11.42.16.556318@googlemail.com> <20130128143907.GA2940@kroah.com> <pan.2013.01.28.20.33.44.918987@googlemail.com> <20130128204639.GB7759@google.com> <20130212004023.GA8427@xanatos> <20130212005402.GB10897@google.com>
In-Reply-To: <20130212005402.GB10897@google.com>
X-Enigmail-Version: 1.5
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 12.02.2013 01:54, Jonathan Nieder wrote:
> Sarah Sharp wrote:
> 
>> Can you turn on CONFIG_USB_DEBUG and CONFIG_USB_XHCI_HCD_DEBUGGING,
>> recompile the 3.7.5 kernel, and send me dmesg starting from the point
>> you unmount the device and then power it off?
>>
>> I'd like to keep that patch in stable, but I need to understand what
>> exactly is failing with it.
> 
> Note that Holger ran into the same problem using a mainline (3.8-rc5)
> kernel.

Yup, which is why I'll try 3.8-rc7 first. Glad this has some attention. :)

-h

