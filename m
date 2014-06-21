Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758387AbaFUVQp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Jun 2014 17:16:45 -0400
Received: from mondschein.lichtvoll.de ([194.150.191.11]:39219 "EHLO
	mail.lichtvoll.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755599AbaFUVQn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Jun 2014 17:16:43 -0400
From: Martin Steigerwald <Martin@lichtvoll.de>
To: Pavel Machek <pavel@ucw.cz>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        kernel list <linux-kernel@vger.kernel.org>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        intel-gfx <intel-gfx@lists.freedesktop.org>
Subject: Re: 3.16, i915: less colors in X?
Date: Sat, 21 Jun 2014 23:16:40 +0200
Message-ID: <2527490.06bevSLs0l@merkaba>
User-Agent: KMail/4.14 pre (Linux/3.15.0-tp520; KDE/4.13.1; x86_64; git-4061980; 2014-06-21)
In-Reply-To: <20140621202901.GA3840@amd.pavel.ucw.cz>
References: <alpine.LRH.2.00.1405141435510.30793@twin.jikos.cz> <alpine.LNX.2.00.1406091302560.20782@pobox.suse.cz> <20140621202901.GA3840@amd.pavel.ucw.cz>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am Samstag, 21. Juni 2014, 22:29:01 schrieb Pavel Machek:
> Hi!
> 
> I just test-booted 3.16-rc1, and background in X looked just wrong --
> very noticeable bands on the background gradient. I thought that maybe
> it is just my eyes, but I went back to older kernel, and background is
> ok now.
> 
> I'm trying to figure out how to ask X what color depth it is using...?

I think:

martin@merkaba:~> xdpyinfo | grep -i "depth of root"
  depth of root window:    24 planes

but am not completely sure.
 
> This is thinkpad x60 with Debian 6.0.9.

Ciao,
-- 
Martin 'Helios' Steigerwald - http://www.Lichtvoll.de
GPG: 03B0 0D6C 0040 0710 4AFA  B82F 991B EAAC A599 84C7
