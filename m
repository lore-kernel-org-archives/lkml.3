Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755255Ab3KWMhZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Nov 2013 07:37:25 -0500
Received: from mail-la0-f41.google.com ([209.85.215.41]:52197 "EHLO
	mail-la0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751304Ab3KWMhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Nov 2013 07:37:22 -0500
MIME-Version: 1.0
Date: Sat, 23 Nov 2013 20:37:20 +0800
Message-ID: <CAKH5=LuVQ1Vdke=yJiemirCKWwQo3VmXVf1uawNTeB0yNQd8+Q@mail.gmail.com>
Subject: /bin/sh: line 11: /bin/arch: No such file or directory ??
From: Naughtboy <skylvlinux@gmail.com>
To: linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

dear all   i meet  thefollw problem , look for help ,  if you kown the
solution ,!!
thanks advance!!!
        CC=mipsel-uclibc-linux26-gcc ./configure \
                --target=mipsel-uclibc-linux26 \
                --host=mipsel-uclibc-linux26 \
                --build=`/bin/arch`-linux \
                --enable-shared \
                --disable-static \
                --disable-cups \
                --disable-iprint \
                --disable-pie \
                --disable-fam \
                --localstatedir=/tmp/samba/lib/ \
                --with-configdir=/tmp/samba/lib/ \
                --with-privatedir=/tmp/samba/private \
                --with-lockdir=/tmp/samba/var/locks \
                --with-piddir=/tmp/samba/var/locks \
                --without-ldap \
                --without-sys-quotas \
                --without-cifsmount \
                --prefix=/tmp/samba; \
        )
/bin/sh: line 11: /bin/arch: No such file or directory
SAMBA VERSION: 3.0.25b
LIBREPLACE_LOCATION_CHECKS: START
checking build system type... configure: error: /bin/sh ./config.sub
-linux failed
configure: WARNING: Cache variable ac_cv_build contains a newline.
make[3]: *** [configure] Error 1
