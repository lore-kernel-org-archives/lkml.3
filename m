Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758179Ab3GMRD7 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 13 Jul 2013 13:03:59 -0400
Received: from mail-la0-f52.google.com ([209.85.215.52]:44675 "EHLO
	mail-la0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751071Ab3GMRD5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 13 Jul 2013 13:03:57 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1307130238190.31878@aurora.sdinet.de>
References: <CAB=NE6XyC0Svxh8yeVNvnpdkVBTWEAcmi8wZocc6MC=kxLs2iw@mail.gmail.com>
 <alpine.DEB.2.10.1307130238190.31878@aurora.sdinet.de>
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Sat, 13 Jul 2013 10:03:35 -0700
X-Google-Sender-Auth: oK5LCgGXLJeg4lvyAKGPaZ-yI-o
Message-ID: <CAB=NE6UDgme=Y6inA1DSQSPt1j9FtWQPq-j4TK6P7AwhATK6PQ@mail.gmail.com>
Subject: Re: [ANN] backports-v3.10 released - first release!
To: Sven-Haegar Koch <haegar@sdinet.de>
Cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 12, 2013 at 5:40 PM, Sven-Haegar Koch <haegar@sdinet.de> wrote:
> On Fri, 12 Jul 2013, Luis R. Rodriguez wrote:
>
>> Kicked out the first Linux kernel backports release under the new
>> project name, "backports" that hopefully clarifies this a generic
>> backport project now. Backported subsystems in this release:
>
>> [0] http://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.10/backports-3.10-1.tar.bz2
>
> Did you perhaps re-upload the 3.10-rc1 backports archive?
>
> haegar@blackhole:~/src/3.2.0$ tar tvf backports-3.10-1.tar.bz2 | head -n 2
> drwxr-xr-x mcgrof/mcgrof     0 2013-05-19 03:06 backports-3.10-rc1-1/
> -rw-r--r-- mcgrof/mcgrof  4164 2013-05-18 22:57 backports-3.10-rc1-1/Kconfig.versions
> ...
>
> $ cat versions
> BACKPORTS_VERSION="v3.10-rc1-1-0-g80112f6"
> BACKPORTED_KERNEL_VERSION="v3.10-rc1-0-gf722406"
> BACKPORTED_KERNEL_NAME="Linux"

Indeed. Pushed out -2 release:

https://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.10/backports-3.10-2.tar.bz2

  Luis
