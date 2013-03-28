Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756419Ab3C1P4R (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Mar 2013 11:56:17 -0400
Received: from pindarots.xs4all.nl ([80.101.128.228]:36430 "EHLO
	pindarots.xs4all.nl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752715Ab3C1P4Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Mar 2013 11:56:16 -0400
Message-ID: <51546814.7080509@xs4all.nl>
Date: Thu, 28 Mar 2013 16:56:04 +0100
From: Udo van den Heuvel <udovdh@xs4all.nl>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130311 Thunderbird/17.0.4
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: Bjorn Helgaas <bhelgaas@google.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: 3.8.4: ohci question
References: <Pine.LNX.4.44L0.1303281034160.1652-100000@iolanthe.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1303281034160.1652-100000@iolanthe.rowland.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2013-03-28 15:35, Alan Stern wrote:
>>> When my dmesg gives me a growing number of lines like the one below,
>>> what is going on?
>>>
>>>  ohci_hcd 0000:00:12.0: urb ffff88023025c500 path 2 ep1in 6c160000 cc 6
>>> --> status -71
>>>
>>> Please let me know!
> 
> -71 errors indicate a low-level problem on the USB bus.  Generally it
> means that the device isn't sending any packets.  Maybe the device's
> firmware has crashed or maybe it has been disconnected.

Could it be due to a defect in the mainboard?
Or the device connected to that port?

Kind regards,
Udo

