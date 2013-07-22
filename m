Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933205Ab3GVT34 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 15:29:56 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932676Ab3GVT3z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 15:29:55 -0400
Message-ID: <51ED882F.9080801@nod.at>
Date: Mon, 22 Jul 2013 21:29:51 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com> <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com> <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com> <20130722124047.GL4165@ZenIV.linux.org.uk> <CALkWK0=bAwDxbLEtHOThjY58BmWCrFYgZm9GaLfEnF5vpu1VJw@mail.gmail.com> <51ED31AF.8000309@nod.at> <CALkWK0ki0JN_uB3VNr=j0hAcEhiT_Xr+xd911-AGy5sjd95GFg@mail.gmail.com> <51ED3CF5.7000609@nod.at> <CALkWK0kwBaNHfH6fjtnCTxseWcXfEvNFgFovZVkz5E0_fxiHWA@mail.gmail.com>
In-Reply-To: <CALkWK0kwBaNHfH6fjtnCTxseWcXfEvNFgFovZVkz5E0_fxiHWA@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2013 17:33, schrieb Ramkumar Ramachandra:
> Richard Weinberger wrote:
>> Again what problem are you trying to solve?
>> If you want a getty on /dev/tty0, run:
> 
> To get systemd to do that for me automatically :)
> 
> It automatically does the right thing when it detects xen, bochs,
> qemu, vmware, microsoft, oracle, chroot, openvz, and lxc.  So, why not
> uml?

Ask systemd folks. UML exists much longer than systemd.

> [1/2] is about getting it to active console-getty.service when uml is detected.
> 
> [2/2] is about getting it to disable vconsole-setup.service when uml
> is detected (since it uml doesn't do VT emulation, and the service
> will always fail).
> 
> Too minor a problem?

No, but we won't break existing applications, period.
If you offer me a solution that does not break any existing applications
and solves your systemd issue we can talk. :-)

Thanks,
//richard

