Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753588Ab3HKN1U (ORCPT <rfc822;w@1wt.eu>);
	Sun, 11 Aug 2013 09:27:20 -0400
Received: from medousa.rus.uni-stuttgart.de ([129.69.1.57]:38103 "EHLO
	medousa.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753459Ab3HKN1T (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 11 Aug 2013 09:27:19 -0400
Message-ID: <52079133.5060507@rus.uni-stuttgart.de>
Date: Sun, 11 Aug 2013 15:27:15 +0200
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

In the meantime, I replaced the entire usb subsystem from the 2.6.32.1 
by that of 2.6.31.14, plus minor patches, but no avail. Still hangs. So 
it's unlikely it's someplace in usb. I'll try next with the PCMCIA 
subsystem... )-:

Greetings,
	Thomas


