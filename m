Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932493Ab3IOQue (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Sep 2013 12:50:34 -0400
Received: from one.firstfloor.org ([193.170.194.197]:34523 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932344Ab3IOQud (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Sep 2013 12:50:33 -0400
Date: Sun, 15 Sep 2013 18:50:30 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Hui Zhu <teawater@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: KGTP (Linux debugger and tracer) 20130915 release (bugs fix
 and pdf doc)
Message-ID: <20130915165030.GU18242@two.firstfloor.org>
References: <CANFwon1yAeqsDCq7rs=ak3pEUD=sMd81t3C45yTZF+TPLmGOBw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CANFwon1yAeqsDCq7rs=ak3pEUD=sMd81t3C45yTZF+TPLmGOBw@mail.gmail.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Sep 15, 2013 at 03:58:44PM +0800, Hui Zhu wrote:
> Hi guys,
> 
> KGTP (http://code.google.com/p/kgtp/) is a flexible, lightweight and
> realtime Linux debugger and tracer.
> To use it, you don't need patch or rebuild the Linux kernel. Just
> build KGTP module and insmod it is OK.

I see the source tree still has patches. Are they merely to build
inside the kernel tree? Or is there some functionality that
would benefit from patching?

Real time kernel debugging seems like a useful functionality
and mainline should probably support it.

-Andi
