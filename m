Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757977Ab3GMAlc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Jul 2013 20:41:32 -0400
Received: from blackhole.sdinet.de ([176.9.52.58]:37522 "EHLO mail.sdinet.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950Ab3GMAlb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Jul 2013 20:41:31 -0400
Date: Sat, 13 Jul 2013 02:40:44 +0200 (CEST)
From: Sven-Haegar Koch <haegar@sdinet.de>
To: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
cc: "backports@vger.kernel.org" <backports@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [ANN] backports-v3.10 released - first release!
In-Reply-To: <CAB=NE6XyC0Svxh8yeVNvnpdkVBTWEAcmi8wZocc6MC=kxLs2iw@mail.gmail.com>
Message-ID: <alpine.DEB.2.10.1307130238190.31878@aurora.sdinet.de>
References: <CAB=NE6XyC0Svxh8yeVNvnpdkVBTWEAcmi8wZocc6MC=kxLs2iw@mail.gmail.com>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 12 Jul 2013, Luis R. Rodriguez wrote:

> Kicked out the first Linux kernel backports release under the new
> project name, "backports" that hopefully clarifies this a generic
> backport project now. Backported subsystems in this release:

> [0] http://www.kernel.org/pub/linux/kernel/projects/backports/stable/v3.10/backports-3.10-1.tar.bz2

Did you perhaps re-upload the 3.10-rc1 backports archive?

haegar@blackhole:~/src/3.2.0$ tar tvf backports-3.10-1.tar.bz2 | head -n 2
drwxr-xr-x mcgrof/mcgrof     0 2013-05-19 03:06 backports-3.10-rc1-1/
-rw-r--r-- mcgrof/mcgrof  4164 2013-05-18 22:57 backports-3.10-rc1-1/Kconfig.versions
...

$ cat versions 
BACKPORTS_VERSION="v3.10-rc1-1-0-g80112f6"
BACKPORTED_KERNEL_VERSION="v3.10-rc1-0-gf722406"
BACKPORTED_KERNEL_NAME="Linux"

c'ya
sven-haegar

-- 
Three may keep a secret, if two of them are dead.
- Ben F.
