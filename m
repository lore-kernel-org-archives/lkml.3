Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752303Ab3FNHtW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 03:49:22 -0400
Received: from mail-wg0-f47.google.com ([74.125.82.47]:61434 "EHLO
	mail-wg0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752050Ab3FNHtV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 03:49:21 -0400
Message-ID: <51BACB03.8010400@gmail.com>
Date: Fri, 14 Jun 2013 09:49:23 +0200
From: Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:10.0.12) Gecko/20130116 Icedove/10.0.12
MIME-Version: 1.0
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>,
        Riccardo Magliocchetti <riccardo.magliocchetti@gmail.com>,
        Greg KH <gregkh@linuxfoundation.org>
Subject: perf bench does compile in 3.9.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

on my 64bit kernel / 32 bit userspace system with libnuma 2.0.8 i get this error on linux 3.9.6:

bench/numa.c: In function ‘worker_thread’:
bench/numa.c:1113:20: error: comparison between signed and unsigned integer expressions [-Werror=sign-compare]
bench/numa.c:1161:6: error: format ‘%lx’ expects argument of type ‘long unsigned int’, but argument 5 has type ‘u64’ [-Werror=format]

Haven't tried latest git but it looks like there's the same issue.

thanks,
riccardo
