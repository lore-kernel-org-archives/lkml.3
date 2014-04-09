Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757481AbaDIBDw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Apr 2014 21:03:52 -0400
Received: from mail-bk0-f53.google.com ([209.85.214.53]:42479 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756416AbaDIBDt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Apr 2014 21:03:49 -0400
MIME-Version: 1.0
From: "Luis R. Rodriguez" <mcgrof@do-not-panic.com>
Date: Tue, 8 Apr 2014 18:03:27 -0700
X-Google-Sender-Auth: FNtlRoq0oqTneWdt6iHukFrvu7o
Message-ID: <CAB=NE6VvyBKzEg=ErZzQMktY8eLytQ21JCPrOQbxvZ9m-nqHkw@mail.gmail.com>
Subject: Bumping required kernels to 3.0 for Linux backports ?
To: "backports@vger.kernel.org" <backports@vger.kernel.org>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Felix Fietkau <nbd@openwrt.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Folks,

we have a age old dance of random parties, in particular the embedded
folks, ending up with random ancient kernels on embedded devices. I've
tried to carefully document a few ideas on why and how I believe we
can make automatic kernel backporting scale [0] and part of this will
be to try to bring consensus about a unified front to persuade users,
partners, customers, whatever, to be at least on a kernel listed as
supported on kernel.org. Today we backport down to the last 30
kernels, from 2.6.24 up to 3.14 and while this is manageable right now
I expect the number of supported drivers and features to keep
increasing (I've stopped counting). I am very aware of the reasons to
support a slew of old kernels, but its nothing but our own fault for
not educating enough about the importance on upgrading. I realize this
is an age old issue, but since I think we need scale backports and
wish to remove older kernels from it fast, I wanted to see if any
folks might have ideas on what can help here other than saying, 'if
you use Linux backports, your drivers will be automatically backported
and supported'.

To start off -- what's the *last* kernel you realistically need for
your users to use backports right now? Is it really 2.6.25? Would
anyone kick and scream if for the backports-3.15 release try take
things up to support only down to least 3.0 *right now* ?

[0] http://www.do-not-panic.com/2014/04/automatic-linux-kernel-backporting-with-coccinelle.html

  Luis
