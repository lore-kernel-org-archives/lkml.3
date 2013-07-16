Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933442Ab3GPP7S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 16 Jul 2013 11:59:18 -0400
Received: from b.ns.miles-group.at ([95.130.255.144]:1660 "EHLO radon.swed.at"
	rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S932441Ab3GPP7O (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 16 Jul 2013 11:59:14 -0400
Message-ID: <51E56DCB.3040108@nod.at>
Date: Tue, 16 Jul 2013 17:59:07 +0200
From: Richard Weinberger <richard@nod.at>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130620 Thunderbird/17.0.7
MIME-Version: 1.0
To: Ramkumar Ramachandra <artagnon@gmail.com>
CC: LKML <linux-kernel@vger.kernel.org>, Jeff Dike <jdike@addtoit.com>,
        Al Viro <viro@zeniv.linux.org.uk>
Subject: Re: [QUERY] User-Mode Linux and /dev/tty*
References: <CALkWK0k2BsoxwMLHSWmmrFXkvMBiWDG1b0NXrfR6i95=tFPMXw@mail.gmail.com>
In-Reply-To: <CALkWK0k2BsoxwMLHSWmmrFXkvMBiWDG1b0NXrfR6i95=tFPMXw@mail.gmail.com>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

Am 16.07.2013 17:54, schrieb Ramkumar Ramachandra:
> Hi,
> 
> So, I was trying to boot User-Mode Linux with a modern rootfs with
> systemd on it, and found that it wouldn't present me a prompt.  I dug
> further, and found out that getty is not able to open /dev/tty1; I
> then tried the console-getty.service (which uses /dev/console), and it
> worked.  The reason it doesn't work out of the box is that systemd is
> not able to figure out whether or not a virtual console subsystem is
> present: /dev/tty0 is present for some reason (although I'm not sure
> it's a virtual console), and this confuses systemd.
> 
> So, my question is: does um Linux have a virtual console subsystem?
> If so, then why doesn't it seem to work?  If not, why does /dev/tty0
> exist?

UML does not have CONFIG_VT.
But recent systemd versions can deal with that.

Thanks,
//richard

