Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758736Ab3HJTs2 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 15:48:28 -0400
Received: from medousa.rus.uni-stuttgart.de ([129.69.1.57]:42484 "EHLO
	medousa.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754335Ab3HJTs1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 15:48:27 -0400
Message-ID: <52069907.6090602@rus.uni-stuttgart.de>
Date: Sat, 10 Aug 2013 21:48:23 +0200
From: Thomas Richter <richter@rus.uni-stuttgart.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
References: <Pine.LNX.4.44L0.1308100801470.31571-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308100801470.31571-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.2013 14:04, Alan Stern wrote:
> On Sat, 10 Aug 2013, Thomas Richter wrote:

>
>>   What about other usb modules? I would
>> probably need a short recap on through which modules the user data flows
>> before the write is triggered, and which modules are involved in the
>> configuration of the NEC ehci host adapter.
>
> Start with just the ones you have identified.  If that doesn't fix the
> problem then we can look further.

Sorry, need to look further. I replaced ehci-pci from 2.6.31.14, and 
yenta_socket as well. No changes were necessary. Also replaced ehci-hcd, 
but that required two minor changes because in 2.6.32, apparently, one 
hardware related structure was pulled out of the ehci structure.

Still did not make any difference, still locks up.

What's the next module up in the call chain I should be looking at?

Greetings,
	Thomas
