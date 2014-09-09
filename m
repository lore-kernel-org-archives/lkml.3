Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755584AbaIIGsL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 02:48:11 -0400
Received: from mail-la0-f48.google.com ([209.85.215.48]:39013 "EHLO
	mail-la0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751747AbaIIGsJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 02:48:09 -0400
MIME-Version: 1.0
In-Reply-To: <CAKszPgv4ML2byWtYCxHY0KNmW+VbPYWY3uQDr_XLg_9AFx960Q@mail.gmail.com>
References: <CAG-aW04-=7rvPjLGqAWZ2oWT4K4EZ5gc96ZWpBo101u=f2+6EQ@mail.gmail.com>
 <CAG-aW06pKUeCddJCAN7cDDcs-T2jmjV33zxdh-jyVSx1uhq2Ww@mail.gmail.com>
 <CAKszPgvjBE5y35guVRXu7kp3nVZa4KPgh=AezVL-UXq=idRc-Q@mail.gmail.com>
 <53EC8579.1030008@redhat.com> <20140814220740.GA32475@xanatos>
 <CAKszPgservaZfMsV=c7c3yuPtm6cc2J14auDkG-pE-JPdrEXtQ@mail.gmail.com>
 <53F78B66.6040202@redhat.com> <CAKszPgs3ULrDDTo=W+MsD-5PCd9yVNj3uxJ3LtGM9QTMT346aQ@mail.gmail.com>
 <CAKszPgv4ML2byWtYCxHY0KNmW+VbPYWY3uQDr_XLg_9AFx960Q@mail.gmail.com>
From: Claudio Bizzarri <claudio.bizzarri@gmail.com>
Date: Tue, 9 Sep 2014 08:47:47 +0200
Message-ID: <CAKszPgtHxncbwwDPAxSDMK4zNx0oktR-qE9qigrqru58tdd9=A@mail.gmail.com>
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

Hi to all,

I've installed new 3.16.2 kernel, and now:
- if I use an USB 3.0 cable I've same crash as said using 3.16.1 version;
- if I use an USB 2.0 cable works, I've made a complete backup without
any problem.

As told, tell me if I can help your works to determine how to resolve this bug.

Ciao
Claudio

2014-08-23 12:07 GMT+02:00 Claudio Bizzarri <claudio.bizzarri@gmail.com>:
>
> I must make a correction to what I said earlier: on kernel 3.16.1 if I
> use a normal micro USB cable (not USB 3.0 one) ...
