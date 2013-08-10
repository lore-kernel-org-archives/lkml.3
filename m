Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S968468Ab3HJIgT (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 04:36:19 -0400
Received: from charybdis.rus.uni-stuttgart.de ([129.69.1.58]:45089 "EHLO
	charybdis.rus.uni-stuttgart.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S968423Ab3HJIgQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 04:36:16 -0400
Message-ID: <5205FB76.5010606@rus.uni-stuttgart.de>
Date: Sat, 10 Aug 2013 10:36:06 +0200
From: Thomas Richter <richter@rus.uni-stuttgart.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Alan Stern <stern@rowland.harvard.edu>
CC: linux@brodo.de, linux-kernel@vger.kernel.org
Subject: Re: [HANG] Trouble with NEC-based USB adapter in PCMCIA slot on E7110
References: <Pine.LNX.4.44L0.1308092103320.23882-100000@netrider.rowland.org>
In-Reply-To: <Pine.LNX.4.44L0.1308092103320.23882-100000@netrider.rowland.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10.08.2013 03:07, Alan Stern wrote:

>> Nope. udevd refuses to start and says that it requires at least 2.6.32,
>> which means that apparently something changed in the kernel-userland
>> interface in 2.6.32. Thus, my conclusion that there's probably something
>> nasty going on in userland with udev.
>
> What about the old udev with the newer kernel?

Well, I extracted now the old udev from the knoppix where I took the 
kernel from. It puked on a couple of the rules from the new system, but 
there was enough in the system to allow me to mount the usb ports. And 
that worked. So, old kernel plus old udev plus new rules -> works. It's 
at least not the udev rules in my new system that are at fault.

I'm now trying the latest 2.6.31.xx kernel with identical configuration 
and check how that is going.

Greetings,
	Thomas
