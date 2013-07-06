Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751452Ab3GFEnI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Jul 2013 00:43:08 -0400
Received: from mail.free-electrons.com ([94.23.35.102]:53611 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750724Ab3GFEnH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Jul 2013 00:43:07 -0400
Message-ID: <51D7A057.8090504@free-electrons.com>
Date: Sat, 06 Jul 2013 06:43:03 +0200
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: linux-usb@vger.kernel.org,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Why no USB id list in the kernel sources?
References: <51D73BCD.1030401@free-electrons.com> <20130705214318.GA20918@kroah.com>
In-Reply-To: <20130705214318.GA20918@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,

On 07/05/2013 11:43 PM, Greg KH wrote:
> On Fri, Jul 05, 2013 at 11:34:05PM +0200, Michael Opdenacker wrote:
>> Hi,
>>
>> I'm wondering why there is no include/linux/usb_ids.h (or
>> include/linux/usb/ids.h) file in the same way there is a
>> include/linux/pci_ids.h for PCI.
> Because that way lies madness, we have learned from our mistakes and do
> not want to repeat them again :)
>
> It turns out that the pci_ids file isn't a good idea, it's a merge mess,
> and only really works when you have ids that are shared across different
> drivers.  In the end, that is a very small number, and it's just not
> worth the time and effort to do this in a centralized way.
>
> Hope this helps explain things, if you want more details, dig into the
> linux usb mailing list about 10-15 years ago when this decision was
> made.

I understand better now, thanks. It's true that the added value would
have been relatively small anyway.

Thanks for your time!

Cheers,

Michael.
>
> thanks,
>
> greg k-h


-- 
Michael Opdenacker, Free Electrons
Embedded Linux, Kernel and Android engineering
http://free-electrons.com
+33 484 258 098

