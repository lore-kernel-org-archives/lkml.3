Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757500Ab3GVPeW (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 11:34:22 -0400
Received: from mail-ie0-f180.google.com ([209.85.223.180]:60329 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757458Ab3GVPeT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 11:34:19 -0400
MIME-Version: 1.0
In-Reply-To: <51ED3CF5.7000609@nod.at>
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com>
 <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com>
 <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com>
 <20130722124047.GL4165@ZenIV.linux.org.uk> <CALkWK0=bAwDxbLEtHOThjY58BmWCrFYgZm9GaLfEnF5vpu1VJw@mail.gmail.com>
 <51ED31AF.8000309@nod.at> <CALkWK0ki0JN_uB3VNr=j0hAcEhiT_Xr+xd911-AGy5sjd95GFg@mail.gmail.com>
 <51ED3CF5.7000609@nod.at>
From: Ramkumar Ramachandra <artagnon@gmail.com>
Date: Mon, 22 Jul 2013 21:03:39 +0530
Message-ID: <CALkWK0kwBaNHfH6fjtnCTxseWcXfEvNFgFovZVkz5E0_fxiHWA@mail.gmail.com>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
To: Richard Weinberger <richard@nod.at>
Cc: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Richard Weinberger wrote:
> Again what problem are you trying to solve?
> If you want a getty on /dev/tty0, run:

To get systemd to do that for me automatically :)

It automatically does the right thing when it detects xen, bochs,
qemu, vmware, microsoft, oracle, chroot, openvz, and lxc.  So, why not
uml?

[1/2] is about getting it to active console-getty.service when uml is detected.

[2/2] is about getting it to disable vconsole-setup.service when uml
is detected (since it uml doesn't do VT emulation, and the service
will always fail).

Too minor a problem?
