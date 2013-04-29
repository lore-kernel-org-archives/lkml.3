Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759376Ab3D2WWU (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Apr 2013 18:22:20 -0400
Received: from mail-wg0-f42.google.com ([74.125.82.42]:37186 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757746Ab3D2WWS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Apr 2013 18:22:18 -0400
Date: Tue, 30 Apr 2013 00:22:13 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Linux kbuild ML <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: lwn@lwn.net
Subject: kconfig-frontends-3.9.0.0 released
Message-ID: <20130429222213.GA31039@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

I'm pleased to announce the release of kconfig-frontends 3.9.0.0!
Go download it there:
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.9.0.0.tar.xz
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.9.0.0.tar.bz2

The kconfig-frontends package provides the kconfig parser, as well as all the
kconfig frontends and utilities, packaged using the traditional autotools, so
the kconfig infrastructure is easy to deploy, either locally or system-wide.

What's new since 3.8.0.0:
  - migrated from Hg to git (yeah!)
  - updated from linux-3.9:
    - fix colors with ncursesw
    - parser:
      - allow specifying an alternate prefix at runtime with $CONFIG_
    - frontends:
      - conf : add '\n' to "NEW" symbols when output is redirected (oldconfig)
      - mconf: add load/save buttons
      - mconf: remove legacy "Load/save alternate" menu entries
      - mconf: allow left/right navigation in input boxes
      - nconf: eye-candy on the function-keys line
      - nconf: help text revamp up to speed with current functionality
    - utilities:
      - merge_config: add option to specify output dir
  - handle curses libs with separate libtinfo (eg. Gentoo)

As a reminder, the home for kconfig-frontends is:
  http://ymorin.is-a-geek.org/projects/kconfig-frontends

And the repository can be browsed or git-cloned from:
  http://ymorin.is-a-geek.org/git/kconfig-frontends
It is also possible to clone using the git protocol:
  git://ymorin.is-a-geek.org/kconfig-frontends

kconfig-frontends is not meant to replace the in-tree Linux kconfig, but
really targets third-party projects that want an easy path to following
the evolution of kconfig, without the burden to manually synchronise from
the Linux kernel source tree.

Any comment, any feedback, any patch is welcome! ;-)

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
