Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3IWT7N (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 15:59:13 -0400
Received: from mail-qc0-f170.google.com ([209.85.216.170]:61272 "EHLO
	mail-qc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752778Ab3IWT7L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 15:59:11 -0400
Message-ID: <52409D8A.7010400@converseincode.com>
Date: Mon, 23 Sep 2013 14:59:06 -0500
From: Behan Webster <behanw@converseincode.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: balbi@ti.com
CC: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, Mark Charlebois <charlebm@gmail.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        Linus Torvalds <torvalds@linux-foundation.org>
Subject: Re: [PATCH] usb: gadget LLVMLinux: Removing the use of VLAIS from
 the gadget driver
References: <1375407344-30120-1-git-send-email-behanw@converseincode.com> <52291CAF.1000504@converseincode.com> <20130923193030.GM30811@radagast>
In-Reply-To: <20130923193030.GM30811@radagast>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/23/13 14:30, Felipe Balbi wrote:
> Hi,
>
> On Thu, Sep 05, 2013 at 08:07:11PM -0400, Behan Webster wrote:
>> Replying to my patch email just in case it was missed before.
> I remember there was a discussion of not dropping variable length array
> support, wasn't there ?
There was mostly an objection to the implementation of that patch. The 
new patch follows the advice given by the linux-usb list members at that 
time.

There is increasing interest from various kernel devs (including 
maintainers and above) to be able to use clang to compile the Linux 
kernel. The removal of the use of VLAIS in the kernel is a step in 
allowing that to happen.

Andrzej Pietrasiewicz attended the LLVM microconference at Plumbers last 
week and accepted the USB gadget patch.

Thanks,

Behan

-- 
Behan Webster
behanw@converseincode.com

