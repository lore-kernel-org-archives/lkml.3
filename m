Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752524AbaHWHhm (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Aug 2014 03:37:42 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:40850 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752333AbaHWHhk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Aug 2014 03:37:40 -0400
MIME-Version: 1.0
In-Reply-To: <53F78B66.6040202@redhat.com>
References: <CAG-aW04-=7rvPjLGqAWZ2oWT4K4EZ5gc96ZWpBo101u=f2+6EQ@mail.gmail.com>
 <CAG-aW06pKUeCddJCAN7cDDcs-T2jmjV33zxdh-jyVSx1uhq2Ww@mail.gmail.com>
 <CAKszPgvjBE5y35guVRXu7kp3nVZa4KPgh=AezVL-UXq=idRc-Q@mail.gmail.com>
 <53EC8579.1030008@redhat.com> <20140814220740.GA32475@xanatos>
 <CAKszPgservaZfMsV=c7c3yuPtm6cc2J14auDkG-pE-JPdrEXtQ@mail.gmail.com> <53F78B66.6040202@redhat.com>
From: Claudio Bizzarri <claudio.bizzarri@gmail.com>
Date: Sat, 23 Aug 2014 09:37:19 +0200
Message-ID: <CAKszPgs3ULrDDTo=W+MsD-5PCd9yVNj3uxJ3LtGM9QTMT346aQ@mail.gmail.com>
Subject: Re: Kernel 3.16.0 USB crash
To: Hans de Goede <hdegoede@redhat.com>
Cc: "Nyman, Mathias" <mathias.nyman@intel.com>, Matt <jackdachef@gmail.com>,
        Gerd Hoffmann <kraxel@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        USB list <linux-usb@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Ok, thank you Hans.

When I connect my external USB disk I've 30 seconds before my laptop
freezes: with top command I cannot view nothing: no abnormal cpu
usage, no any strange memory usage.
If I remove disk before 30 seconds my HP EliteBook 850G1 keeps working
as usual. Can I use these 30 seconds to extract some informations that
help to determine what's the problem? How?
/var/log/syslog and dmesg haven't any messages.

System lock is complete: also key CAPS LOCK does not work anymore.

I've tried without X: when computer locks  3 lines appear on console
that are not registered on syslog, I've copied them on paper.

[ 1200.352042] IP: [<ffffffff8179393f>] _raw_spin_lock_irqsave+ 0x01f/0x060
[ 1200.352045] PGD 0
[ 1200.352048] Oops: 0002 [#1] SMP

Ciao,
Claudio

2014-08-22 20:26 GMT+02:00 Hans de Goede <hdegoede@redhat.com>:
>...
> There is no need to try my patch, since the descriptors already limit
> qdepth to 32. No idea what is going on here then.
