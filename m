Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752657AbaAXMhb (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 Jan 2014 07:37:31 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35309 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752365AbaAXMha (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 Jan 2014 07:37:30 -0500
Message-ID: <52E25E5D.1020806@redhat.com>
Date: Fri, 24 Jan 2014 13:36:45 +0100
From: Paolo Bonzini <pbonzini@redhat.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: =?UTF-8?B?VG9yYWxmIEbDtnJzdGVy?= <toralf.foerster@gmx.de>,
        Dave Hansen <dave.hansen@intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>
CC: kernel@gentoo.org, kvm@vger.kernel.org, Gleb Natapov <gleb@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: 3.13 hangs when I tried to start a KVM at a 32 bit stable Gentoo
References: <52DEA270.60803@gmx.de> <52E165B7.6020506@intel.com> <52E16E83.6060301@intel.com> <52E17273.2030200@gmx.de>
In-Reply-To: <52E17273.2030200@gmx.de>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

-----BEGIN PGP SIGNED MESSAGE-----
Hash: SHA1

Il 23/01/2014 20:50, Toralf Förster ha scritto:
| What makes the situation really annyoing - sometimes I just can
| restart my wlan device it the system works normal, but sometimes
| the whole system hangs and for those cases then sometimes not even
| sysrq buttons do work.

Can you reproduce it with the wlan driver disabled completely?

Paolo
-----BEGIN PGP SIGNATURE-----
Version: GnuPG v2.0.22 (GNU/Linux)
Comment: Using GnuPG with Thunderbird - http://www.enigmail.net/

iQIcBAEBAgAGBQJS4l5cAAoJEBvWZb6bTYbyC0AP/jrHp8WUqDjgv/1kJYcYb0+0
cSM8jqcutYCcMAKXTsKGgQj4gWdw7q/bEo4lWAEX8fQqxOfFZjBZjhTuA66XF010
fi+nOCEwjafMUeflPZaSZr34KGSix1FTtmcdzz55Kzkh+A4hZJj2NgaAYr8KFsWW
0hCoW7+MHWTRsNLIZk1ms2H/lItz19gnO9CkNYWqSIxBtx1/le5v8LNi20OkHKCz
mdemG6DSwj9sE+jfezDjZ7jV/a+RBv4Pi0v71YPEUEa7HCiyKxddVAgD0KrvMwzF
2A7H4+rTwsJLnWTKFyMdoeUUz6iC5Rntq+B4ltHVXKjN2O5bG0aqmG+cURbvXrFF
y9EzChdaEikPlYJHp/ci2NOB8NJlB6oEb9uO3k2kRITdWsr3iK5gCZE3fu99ziz4
JmNPUpFGTy5dnQVI/edsuZDyafRYVq3U4CpP+drnWxbic4aH7nCTv2iR5Op4pnhd
LQlmt0MkZAyF9+6XFNBAAfPnfV0YPBHydCxhC2UaOmqqNXiYILW65dCD5aQiXq1y
lQi2dc6i7MYbVmc28I45LV/BFD4zn622c5ges0gKw2bshgzhQm12jWHJ+dMsLDp/
qpFFvaGoqWCNJZo9FCH6vaTiN5KNUyiUOZjvKVa3u959xC9BK8nh3vTWHxinK2Yt
Do62ZMYWJbljdgTvMN7d
=cfJ7
-----END PGP SIGNATURE-----
