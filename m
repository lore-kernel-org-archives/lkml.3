Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934716Ab3BSWOX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 17:14:23 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:36933 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933538Ab3BSWOV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 17:14:21 -0500
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
Organization: BZH lan
To: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: kconfig-frontends-3.8.0.0 release
Date: Tue, 19 Feb 2013 23:14:15 +0100
User-Agent: KMail/1.13.5 (Linux/3.8.0-treguer; KDE/4.4.5; x86_64; ; )
Cc: Jan Engelhardt <jengelh@inai.de>, lwn@lwn.net,
        "Yann E. MORIN" <yann.morin.1998@free.fr>
MIME-Version: 1.0
Content-Type: text/plain;
  charset="utf-8"
Content-Transfer-Encoding: 7bit
Message-Id: <201302192314.15995.yann.morin.1998@free.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

I'm pleased to announce the release of kconfig-frontends 3.8.0.0!
Go download it there:
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.8.0.0.tar.xz
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.8.0.0.tar.bz2

The kconfig-frontends package provides the kconfig parser, as well as all the
kconfig frontends and utilities, packaged using the traditional autotools, so
the kconfig infrastructure is easy to deploy, either locally or system-wide.

What's new since 3.7.0.0:
  - some huge cleanups to the auto-tools infrastructure, kindly
    suggested and mentored by Jan Engelhardt
  - there was no kconfig changes in 3.8

This release marks the first anniversary at maintaining this project. It
has been fun, and I learnt quite a bit since the first announcement here,
roughly one year ago [0].

The first release, 3.3.0-0, has been covered [1] by LWN.net (Hello! :-) ),
and I'm quite proud of such an achievement!

Work on kconfig-frontends would not have been so easy without the works of
the many kernel contributors, and I'd like to take the opportunity to thank
you all for your amazing work!

So, time has come to lay out the plans for the future:
  - continue to release as soon as possible after each kernel release:
    this has proved to be challenging at times, when there are agenda
    conflicts (kernel release during holidays, or just before a conference)
    but is globally manageable;

  - migrate the repository from Hg to git (on-going) ;-)
    being a noob at git at the time I spawned kconfig-frontends, I used
    the tools I knew how to use at the time, in order not to bust the
    repository. Hg has proved to do the job well for me, but now that I'm
    up to speed with git, time has come for a switch;

  - present (lightning-talk-like) the project at a conference
    I'm self-funded, so will concentrate on Europe (and specifically,
    France and neighbouring countries). Not too sure which conference
    for now. Any help chosing? ;-)

As a reminder, the home for kconfig-frontends is:
  http://ymorin.is-a-geek.org/projects/kconfig-frontends

And the repository can be browsed or hg-cloned from:
  http://ymorin.is-a-geek.org/hg/kconfig-frontends

kconfig-frontends is not meant to replace the in-tree Linux kconfig, but
really targets third-party projects that want an easy path to following
the evolution of kconfig, without the burden to manually synchronise from
the Linux kernel source tree.

Any comment, any feedback, any patch is welcome! ;-)

[0] http://marc.info/?l=linux-kbuild&m=132753216310722
[1] https://lwn.net/Articles/487487/

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
