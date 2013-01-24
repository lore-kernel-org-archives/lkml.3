Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751943Ab3AXWSR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Jan 2013 17:18:17 -0500
Received: from fold.natur.cuni.cz ([195.113.57.32]:34255 "HELO
	fold.natur.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1755756Ab3AXWSF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Jan 2013 17:18:05 -0500
Message-ID: <5101B31A.1050408@fold.natur.cuni.cz>
Date: Thu, 24 Jan 2013 23:18:02 +0100
From: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20100101 Firefox/17.0 SeaMonkey/2.14.1
MIME-Version: 1.0
To: Greg KH <gregkh@linuxfoundation.org>
CC: Martin Mokrejs <mmokrejs@fold.natur.cuni.cz>,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Subject: Re: [PATCH] USB: XHCI: fix memory leak of URB-private data
References: <Pine.LNX.4.44L0.1301171031260.1339-100000@iolanthe.rowland.org> <5101AD55.2000008@fold.natur.cuni.cz> <20130124215707.GA30414@kroah.com>
In-Reply-To: <20130124215707.GA30414@kroah.com>
X-Enigmail-Version: 1.4.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Greg KH wrote:
> On Thu, Jan 24, 2013 at 10:53:25PM +0100, Martin Mokrejs wrote:
>> Hi Sarah and Alan,
>>   I just saw 3.7.5 patches announced by Greg but I don't see this path in there.
>> And, don't know but maybe this applies to older stable kernels as well?
>> Where will this patch posted originally to linux-usb land?
>>
>> Ah, is that because the email was actually NOT sent to "stable@"? ;-)
> 
> No.  It's because the patch isn't in Linus's tree yet, which is one of
> the requirements for a patch to be able to get into the stable kernel
> releases.
> 
> Please read the kernel file, Documentation/stable_kernel_rules.txt for
> more details if you are curious.

Thank you Greg!

Aside from the fact that I do not know how much serious a memleak is and whether
it is eligible for -stable. Other than that, it was helpful to read the file.
Will see what happens. Meanwhile will continue running my patched kernel. ;-)
Martin
