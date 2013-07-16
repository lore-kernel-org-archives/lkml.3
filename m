Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933587Ab3GPRkD (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 13:40:03 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S933059Ab3GPRkB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 13:40:01 -0400
Message-ID: <51E5856C.3020504@nod.at>
Date: Tue, 16 Jul 2013 19:39:56 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>
Subject: Re: [PATCH] um/configs: don't use devtmpfs in defconfig
References: <1373993525-25629-1-git-send-email-artagnon@gmail.com> <51E57BC1.4090904@nod.at> <CALkWK0nrDsZiHe2==DQZuHV7id=6gc4UHUj1xXu9jN5cr3SUcQ@mail.gmail.com> <51E57DF3.90304@nod.at> <CALkWK0m0LkjFzOUXRQmdDuS+L7mKA87qCMq=MYX6UrnHXi+XRg@mail.gmail.com> <CALkWK0=qw_K=6+6btjzcMS9VmDdVbF++rN=3-=Kgzu-3xSErrQ@mail.gmail.com> <51E58190.4050808@nod.at> <CALkWK0mDtxNPRnU480k8wiNt+i7gpVHLz8Za4+368_L8bU9Teg@mail.gmail.com>
In-Reply-To: <CALkWK0mDtxNPRnU480k8wiNt+i7gpVHLz8Za4+368_L8bU9Teg@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 16.07.2013 19:36, schrieb Ramkumar Ramachandra:
> Richard Weinberger wrote:
>> BTW: I'll not apply any patch to the kernel if the issue can easily
>> fixed in user space, that's the major reason for my NAK.
> 
> I was just asking for good defaults; I want um Linux to work
> out-of-the-box.  There's really no point in creating bogus devices in
> /dev, and make life unnecessarily hard for user-space applications:
> instead of checking for existence, they'd have to check that all the
> devices work.  I doubt systemd will accept such a patch, just to bend
> over backwards and support um.

Out of the box wont work in all cases.
But you can easily adjust some systemd units.
Like any visualization technology UML comes with some trade-offs.

Thanks,
//richard
