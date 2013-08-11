Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752641Ab3HKIvP (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 04:51:15 -0400
Received: from charon.rus.uni-stuttgart.de ([129.69.1.54]:60181 "EHLO
	charon.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752181Ab3HKIvL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 04:51:11 -0400
Message-ID: <52075079.2060405@rus.uni-stuttgart.de>
Date: Sun, 11 Aug 2013 10:51:05 +0200
From: Thomas Richter <richter@rus.uni-stuttgart.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux-kernel@vger.kernel.org
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
References: <Pine.LNX.4.44L0.1308102140420.10834-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308102140420.10834-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 11.08.2013 03:46, Alan Stern wrote:
> On Sat, 10 Aug 2013, Thomas Richter wrote:
>
>> Sorry, need to look further. I replaced ehci-pci from 2.6.31.14, and
>> yenta_socket as well. No changes were necessary. Also replaced ehci-hcd,
>
> Do you mean that you took the source code for ehci-hcd from the 2.6.31
> kernel, copied it into the source directory for the 2.6.32 kernel, and
> built it there?

Exactly that, yes. Two minor patches were necessary in ehci-hcd, but I 
doubt that this is the source of the problem (just one administration 
structure was pulled out in 2.6.32).

>> but that required two minor changes because in 2.6.32, apparently, one
>> hardware related structure was pulled out of the ehci structure.
>>
>> Still did not make any difference, still locks up.
>>
>> What's the next module up in the call chain I should be looking at?
>
> Have you tried comparing a usbmon trace from 2.6.31 with a comparable
> trace from 2.6.32?  I doubt there will be any important differences,
> but you never know until you try.

Not yet, good idea, thanks.

Thanks,
	Thomas


