Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753843Ab3GWBIl (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 21:08:41 -0400
Received: from szxga02-in.huawei.com ([119.145.14.65]:14023 "EHLO
	szxga02-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753320Ab3GWBIj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 21:08:39 -0400
Message-ID: <51EDD76B.5050407@huawei.com>
Date: Tue, 23 Jul 2013 09:07:55 +0800
From: Li Zefan <lizefan@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Sarah Sharp <sarah.a.sharp@linux.intel.com>
CC: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Guenter Roeck <linux@roeck-us.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Steven Rostedt <rostedt@goodmis.org>, Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, Darren Hart <dvhart@linux.intel.com>,
        Rusty Russell <rusty@rustcorp.com.au>
Subject: Re: mistakes in code vs. maintainer flow mistakes
References: <20130715180403.GD15531@xanatos> <CA+55aFxmV83=_kjsHGbXFwQW9tXdbT6vyEGcuDTC00X0JJvB7w@mail.gmail.com> <20130715184642.GE15531@xanatos> <CA+55aFx+W9V845zcVrUWXvL=qtYYSX=Tj25d4im4gKV5pHA35Q@mail.gmail.com> <20130715195316.GF15531@xanatos> <20130715204135.GH15531@xanatos> <CA+55aFzwfAkWA6JZruXNKX2=xd-oWM=G8FKhWCVn2xkpR_1sUA@mail.gmail.com> <20130718103907.GC23558@gmail.com> <20130718160754.GC5440@xanatos> <20130719092256.GC25784@gmail.com> <20130719190127.GA12990@xanatos>
In-Reply-To: <20130719190127.GA12990@xanatos>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.68.215]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> Perhaps what might help here is a kernel organizational chart.  A graph
> of who sends pull requests to Linus, and their subsystem maintainers.
> For example, in the USB "branch" there would be:
> 
> 				Linus Torvalds
> 			(Linux kernel release engineer)
> 					|
> 					|
> 				Greg Kroah-Hartman
> 				      (USB)
> 					|
> 					|
> 			-------------------------------------------------
> 			|		|		|		|
> 			|		|		|		|
> 		Sarah Sharp		|		|	   Oliver Neukum
> 	(USB3 and USB core)		|		|	(USB NCM and auto-suspend)
> 					|		|
> 				Alan Stern		|
> 			(EHCI/UHCI/OHCI and USB core)	|
> 							|
> 							|
> 						Felipe Balbi
> 					(USB3 plat and USB gadget)
> 

Nice chart, exccept that the complete chart will in no doubt break 80
characters limit. Actually as the hierarchy is quite flat, I can't
image how long the longest line will be.

