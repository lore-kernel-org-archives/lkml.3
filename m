Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751581Ab3KEFIc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Nov 2013 00:08:32 -0500
Received: from h1446028.stratoserver.net ([85.214.92.142]:50480 "EHLO
	mail.ahsoftware.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750704Ab3KEFIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Nov 2013 00:08:31 -0500
Message-ID: <52787D3C.8030009@ahsoftware.de>
Date: Tue, 05 Nov 2013 06:08:12 +0100
From: Alexander Holler <holler@ahsoftware.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130712 Thunderbird/17.0.7
MIME-Version: 1.0
To: Jan Engelhardt <jengelh@inai.de>
CC: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.12 released .. and 4.0 plans?
References: <CA+55aFwLkvSkparyvekdmMyvr6Srw1KkzTBp=_w0oQRWnPpJug@mail.gmail.com> <alpine.LSU.2.11.1311042228350.4847@nerf07.vanv.qr>
In-Reply-To: <alpine.LSU.2.11.1311042228350.4847@nerf07.vanv.qr>
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 04.11.2013 22:46, schrieb Jan Engelhardt:
> 
> On Monday 2013-11-04 01:10, Linus Torvalds wrote:
>>
>> Onto a totally different topic: we're getting to release numbers where
>> I have to take off my socks to count that high again. I'm ok with
>> 3.<low teens> [...] [4.0 "ok, after 3.19 (or whatever),"]
> 
> What would you do when the major number becomes such an unpleasant
> highteen number? (That will be in ~64 years if you wrap after x.19.)

Changing the counting base and going hex would offer some more years. So
after 9.19 he could switch to a.0 instead of 10.0. Or just call it then
LinuxNG and start with 1.0 again.

But to add something serious to the discussion too, I don't see a reason
why to make a bugfix-only version.

There should be no need to spend a version number for a bugfix only time.

E.g. just insert a bugfix-only time (handled like times at -rc7) before
a merge window for a new version. That would give people the possibility
to get their bugfix-patches into mainline in order to get them into the
stable series without the need to spend a version number.

Regards,

Alexander Holler
