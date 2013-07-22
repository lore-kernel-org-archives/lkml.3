Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755920Ab3GVOI6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Jul 2013 10:08:58 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753767Ab3GVOI5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Jul 2013 10:08:57 -0400
Message-ID: <51ED3CF5.7000609@nod.at>
Date: Mon, 22 Jul 2013 16:08:53 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: Al Viro <viro@zeniv.linux.org.uk>, LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] um: change defconfig to stop spawning xterm
References: <1374258017-19606-1-git-send-email-artagnon@gmail.com> <51E988FF.9010201@nod.at> <CALkWK0kj=maJgrLV11h8GzJ-L24KWDzgCAiZa97rieJKUXeW_A@mail.gmail.com> <CALkWK0=0NWediExGCwJ3R-O+7V_9sgGzJPUaXgaTEka5O05N=Q@mail.gmail.com> <20130722124047.GL4165@ZenIV.linux.org.uk> <CALkWK0=bAwDxbLEtHOThjY58BmWCrFYgZm9GaLfEnF5vpu1VJw@mail.gmail.com> <51ED31AF.8000309@nod.at> <CALkWK0ki0JN_uB3VNr=j0hAcEhiT_Xr+xd911-AGy5sjd95GFg@mail.gmail.com>
In-Reply-To: <CALkWK0ki0JN_uB3VNr=j0hAcEhiT_Xr+xd911-AGy5sjd95GFg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 22.07.2013 15:42, schrieb Ramkumar Ramachandra:
> Richard Weinberger wrote:
>> "great user-experience" and other marketing buzzwords belong to Ubuntu land.
> 
> Ubuntu uses upstart; I have no idea why you brought it up.
> 
>> What technical problem are you facing?
>> I'm using systemd distros all day on top of UML.
> 
> I started the thread with two patches [1][2].  Do the patches _not_
> address problems?  Are the problems invalid in some way?  Are the
> commit messages unclear?
> 
> [1]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012153.html
> [2]: http://lists.freedesktop.org/archives/systemd-devel/2013-July/012154.html

Again what problem are you trying to solve?
If you want a getty on /dev/tty0, run:

ln -s /usr/lib/systemd/system/getty@.service /etc/systemd/system/getty.target.wants/getty@tty0.service

Thanks,
//richard
