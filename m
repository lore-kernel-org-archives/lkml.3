Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932956Ab3GDRpA (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 13:45:00 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:37457 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756728Ab3GDRo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 13:44:59 -0400
Date: Thu, 4 Jul 2013 19:44:53 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Linux kbuild ML <linux-kbuild@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Cc: lwn@lwn.net
Subject: kconfig-frontends-3.10.0.0 released
Message-ID: <20130704174453.GC5374@free.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello All!

I'm pleased to announce the release of kconfig-frontends 3.10.0.0!
Go download it there:
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.10.0.0.tar.xz
    http://ymorin.is-a-geek.org/download/kconfig-frontends/kconfig-frontends-3.10.0.0.tar.bz2

The kconfig-frontends package provides the kconfig parser, as well as
all the kconfig frontends and utilities, packaged using the traditional
autotools, so the kconfig infrastructure is easy to deploy, either
locally or system-wide.

What's new since 3.9.0.0:
  - updated from linux-3.10:
    - parser:
      - fix randconfig tristate detection
      - do not override symbols already set
    - frontends:
      - conf : allow specifying the seed for randconfig
      - conf : implement KCONFIG_PROBABILITY for randconfig
      - mconf: print more info for symbol without prompts
      - mconf: add "breadcrumbs" navigation aid
      - mconf: handle keys in empty dialogs
      - mconf: some fixes (NULL pointer dereference, memory leak...)
    - utilities:
      - merge_config: avoid creating unnessary source softlinks
  - misc:
    - BSD- and MacOS-X-related fixes and doc
    - fix lex/yacc checks

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
