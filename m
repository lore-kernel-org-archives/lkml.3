Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762187Ab3EBUxT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 16:53:19 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:14296 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759629Ab3EBUxR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 16:53:17 -0400
X-IronPort-AV: E=Sophos;i="4.87,599,1363158000"; 
   d="scan'208";a="43752833"
From: David Brown <davidb@codeaurora.org>
To: Mark Brown <broonie@kernel.org>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Nicolas Pitre <nico@fluxnic.net>, Richard Kuo <rkuo@codeaurora.org>,
        linux-hexagon@vger.kernel.org
Subject: Re: [GIT PATCH] char/misc patches for 3.10-rc1
References: <20130429162115.GA6893@kroah.com>
	<CA+55aFzefpRz2Y8oW9q0ArrR=XW0POBhy8NSNJ3DrCh9EowLqg@mail.gmail.com>
	<8yafvy92gfs.fsf@huya.qualcomm.com> <201304292316.28464.arnd@arndb.de>
	<20130501161350.GS26160@sirena.org.uk>
Date: Thu, 02 May 2013 13:53:03 -0700
In-Reply-To: <20130501161350.GS26160@sirena.org.uk> (Mark Brown's message of
	"Wed, 1 May 2013 17:13:50 +0100")
Message-ID: <8yay5bxums0.fsf@huya.qualcomm.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mark Brown <broonie@kernel.org> writes:

> On Mon, Apr 29, 2013 at 11:16:28PM +0200, Arnd Bergmann wrote:
>
>> Well, the only reason I see against putting it into drivers/mfd is that
>> this place is becoming a dumping ground for stuff that doesn't have a
>> real home anywhere else. On the other hand, this one would fit better
>> than a lot of drivers that are already there, and it would actually remove
>> the need for a global include/linux/*.h header file as the interface.
>
> Well, this device should have a bunch of function drivers hanging off it
> shouldn't it?  That's pretty much the definition of a MFD.

Perhaps it's better to think of it as the library that other mfd devices
use to talk to their device.  ssbi is not itself an MFD device, it is
part of the other drivers.

David

-- 
sent by an employee of the Qualcomm Innovation Center, Inc.
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
