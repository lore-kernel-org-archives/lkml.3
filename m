Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756609Ab3A2EW7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 23:22:59 -0500
Received: from smtp.multi.fi ([85.134.37.151]:34023 "EHLO smtp.multi.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753567Ab3A2EW6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 23:22:58 -0500
Message-ID: <51074E9D.3040803@mageia.org>
Date: Tue, 29 Jan 2013 06:22:53 +0200
From: Thomas Backlund <tmb@mageia.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130107 Thunderbird/17.0.2
MIME-Version: 1.0
To: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
CC: Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: perf 3.8-rc build failure:  undefined reference to `strlcpy'
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


[tmb@tmb linux-3.8-rc5]$ make -C tools/perf -s V=1 HAVE_CPLUS_DEMANGLE=1 
prefix=%{_prefix} all

...

/tmp/ccJEJv6m.o: In function `main':
:(.text+0x14): undefined reference to `strlcpy'
collect2: ld returned 1 exit status

...

This did not show up in 3.7

--
Thomas
