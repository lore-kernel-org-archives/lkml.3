Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753758AbbATLrx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 06:47:53 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:44715 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753386AbbATLrv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 06:47:51 -0500
MIME-Version: 1.0
From: Divya Vyas <edivya.vyas@gmail.com>
Date: Tue, 20 Jan 2015 17:17:30 +0530
Message-ID: <CAGfiMvBRRRGRJdgkQpubc4BUTeh3m43tFGtCiz1nshjTzikFkg@mail.gmail.com>
Subject: perf data convert error
To: LKML <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


I am getting one error while converting the perf.data to CTF format .


./perf data convert -i perf.data --to-ctf dv_ctf
./perf: symbol lookup error: ./perf: undefined symbol:
bt_ctf_stream_class_get_packet_context_type

While I created perf binary and below is the output :

make DEBUG=1 LIBBABELTRACE_DIR=/opt/libbabeltrace/
  BUILD:   Doing 'make -j4' parallel build
config/Makefile:139: The path 'python-config' is not executable.
config/Makefile:507: Missing perl devel files. Disabling perl
scripting support, consider installing perl-ExtUtils-Embed
config/Makefile:538: No python-config tool was found
config/Makefile:538: Python support will not be built
config/Makefile:610: No bfd.h/libbfd found, install
binutils-dev[el]/zlib-static to gain symbol demangling

Auto-detecting system features:
...                         dwarf: [ on  ]
...                         glibc: [ on  ]
...                          gtk2: [ on  ]
...                      libaudit: [ on  ]
...                        libbfd: [ OFF ]
...                        libelf: [ on  ]
...                       libnuma: [ on  ]
...                       libperl: [ OFF ]
...                     libpython: [ OFF ]
...                      libslang: [ on  ]
...                     libunwind: [ on  ]
...            libdw-dwarf-unwind: [ on  ]
...                 libbabeltrace: [ on  ]
...                          zlib: [ on  ]
...     DWARF post unwind library: libunwind
