Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933022Ab3GCQFl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 12:05:41 -0400
Received: from mail-oa0-f46.google.com ([209.85.219.46]:44395 "EHLO
	mail-oa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932369Ab3GCQFj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 12:05:39 -0400
MIME-Version: 1.0
From: Lucas De Marchi <lucas.de.marchi@gmail.com>
Date: Wed, 3 Jul 2013 13:05:18 -0300
Message-ID: <CAKi4VALqpeXW4xygys1Lvr03wrVD8ms59u-dwopkvda=GagrMA@mail.gmail.com>
Subject: [ANNOUNCE] kmod 14
To: linux-modules <linux-modules@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Rusty Russell <rusty@rustcorp.com.au>,
        "systemd-devel@lists.freedesktop.org" 
	<systemd-devel@lists.freedesktop.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-14.tar.xz
ftp://ftp.kernel.org/pub/linux/utils/kernel/kmod/kmod-14.tar.sign

kmod 14 is out.

Some bug fixes and a new "static-nodes" command to parse
modules.devname. It was a very calm release cycle.

For the reasoning behind removing "--enable-static": this caused
problems in real world with people linking to libkmod and since it's
not recommended it has been disabled.  I wrote to linux-modules and
systemd-devel mailing lists a while back on how to fix it if anybody
cares. Otherwise it stays disabled.

Thanks to everyone involved in this release. Shortlog is below.


Cheers
Lucas De Marchi

---

Chengwei Yang (2):
      Several minor fixes for documentation
      Add document for exported enums

Jan Luebbe (1):
      libkmod: Avoid calling syscall() with -1

Johannes Berg (1):
      modprobe: don't check refcount with remove command

Lucas De Marchi (20):
      TODO: update and reorder
      testsuite: errno is a positive number
      Use _Static_assert
      Use static assertions for sizeof checks
      kmod: It's an error not to have modules.devname
      static-nodes: Fix indentation
      Add format attribute and fix issues
      build-sys: Add AM_V_XSLT to rule creating man pages
      libkmod-module: Don't pass NULL pointer to memcpy
      libkmod-module: Don't pass NULL ctx to kmod_log
      libkmod-index: Return early if readroot failed
      TODO: Add some entries
      Fix coding style
      missing: Don't call syscall() with syscallno == -1
      Revert "missing: Don't call syscall() with syscallno == -1"
      Add travis-ci config file
      build-sys: do not allow --enable static
      static-nodes: Better -f option description
      tools: Use test/kmod instead of kmod-nolib
      kmod 14

Tom Gundersen (2):
      tools: add static-nodes tool
      static-nodes: tmpfiles - also create parents directories of device nodes
