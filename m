Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754254Ab3IPN2l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 09:28:41 -0400
Received: from mail-ob0-f169.google.com ([209.85.214.169]:34661 "EHLO
	mail-ob0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753990Ab3IPN2j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 09:28:39 -0400
MIME-Version: 1.0
In-Reply-To: <20130915165030.GU18242@two.firstfloor.org>
References: <CANFwon1yAeqsDCq7rs=ak3pEUD=sMd81t3C45yTZF+TPLmGOBw@mail.gmail.com>
 <20130915165030.GU18242@two.firstfloor.org>
From: Hui Zhu <teawater@gmail.com>
Date: Mon, 16 Sep 2013 21:27:58 +0800
Message-ID: <CANFwon1RuK6Q3xGdai7HWB2zRwmjsXHqUx2Gzwh9cK72KqgxpA@mail.gmail.com>
Subject: Re: KGTP (Linux debugger and tracer) 20130915 release (bugs fix and
 pdf doc)
To: Andi Kleen <andi@firstfloor.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 12:50 AM, Andi Kleen <andi@firstfloor.org> wrote:
> On Sun, Sep 15, 2013 at 03:58:44PM +0800, Hui Zhu wrote:
>> Hi guys,
>>
>> KGTP (http://code.google.com/p/kgtp/) is a flexible, lightweight and
>> realtime Linux debugger and tracer.
>> To use it, you don't need patch or rebuild the Linux kernel. Just
>> build KGTP module and insmod it is OK.
>
> I see the source tree still has patches. Are they merely to build
> inside the kernel tree? Or is there some functionality that
> would benefit from patching?

The patchs help some people include KGTP to them special Linux Kernel
tree.  Its functions are same with function of modules.

>
> Real time kernel debugging seems like a useful functionality
> and mainline should probably support it.

Thanks.  I will try to make a patch for upstream later.

Best,
Hui

>
> -Andi
