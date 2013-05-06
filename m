Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753330Ab3EFJpG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 05:45:06 -0400
Received: from zimbra.linbit.com ([212.69.161.123]:38323 "EHLO
	zimbra.linbit.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752700Ab3EFJpE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 05:45:04 -0400
X-Greylist: delayed 602 seconds by postgrey-1.27 at vger.kernel.org; Mon, 06 May 2013 05:45:04 EDT
From: Philipp Reisner <philipp.reisner@linbit.com>
To: Chris Boot <bootc@bootc.net>
Cc: Lars Ellenberg <lars.ellenberg@linbit.com>, linux-kernel@vger.kernel.org
Subject: Re: drbd: kernels 3.7 => 3.8 broken userspace compatibility
Date: Mon, 06 May 2013 11:34:58 +0200
Message-ID: <1719169.QMPV9M3OpB@fat-tyre>
User-Agent: KMail/4.8.5 (Linux/3.2.0-40-lowlatency; KDE/4.8.5; x86_64; ; )
In-Reply-To: <518770DC.10608@bootc.net>
References: <518770DC.10608@bootc.net>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Montag, 6. Mai 2013, 09:59:08 schrieb Chris Boot:
> Hi all,
> 
> I upgraded from a 3.7.x kernel to a 3.8.x kernel on a test machine
> running DRBD, and found myself unable to bring up my DRBD devices. I'm
> using the 8.3.13 userspace tools as shipped in Debian Wheezy, which work
> fine on the 3.7 kernel, but they appear to hang when using the 3.8
> kernel and cannot set up the device.
> 
> The 3.8 kernel appears to introduce drbd 8.4.2 rather than the 8.3.13
> available in 3.7.
> 
[...]
> Even if the kernel did require new userspace tools, should there not be
> some better mechanism to notify the user they must upgrade them before
> things will work? At the moment all I see without strace is:
> 
> # drbdadm attach r0
> DRBD module version: 8.4.2
>    userland version: 8.3.13
> you should upgrade your drbd tools!
  ^^^^
This message is a clear hint, isn't it?

See also https://lkml.org/lkml/2012/11/9/103

Fitting user space tools are available since 2011. The new tools
can deal with both interfaces.

Best,
 Phil
