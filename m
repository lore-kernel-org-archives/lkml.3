Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab3LWOsx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Dec 2013 09:48:53 -0500
Received: from mail-qe0-f41.google.com ([209.85.128.41]:47624 "EHLO
	mail-qe0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932091Ab3LWOsv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Dec 2013 09:48:51 -0500
Date: Mon, 23 Dec 2013 11:48:45 -0300
From: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
To: Stefan Beller <stefanbeller@googlemail.com>
Cc: a.p.zijlstra@chello.nl, paulus@samba.org, mingo@redhat.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] perf tools: Ignore feature tests
Message-ID: <20131223144845.GA13194@ghostprotocols.net>
References: <1387788992-11536-1-git-send-email-stefanbeller@googlemail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1387788992-11536-1-git-send-email-stefanbeller@googlemail.com>
X-Url: http://acmel.wordpress.com
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Em Mon, Dec 23, 2013 at 09:56:32AM +0100, Stefan Beller escreveu:
> The binaries to be ignored are created by
> 	linux/tools $ make perf

Please see:

http://lkml.kernel.org/r/52B52B9B.50708@gmail.com

I just applied it, there was some discussion to culminate in that patch.

- Arnaldo
 
> Signed-off-by: Stefan Beller <stefanbeller@googlemail.com>
> ---
>  tools/perf/config/feature-checks/.gitignore | 43 +++++++++++++++++++++++++++++
>  1 file changed, 43 insertions(+)
>  create mode 100644 tools/perf/config/feature-checks/.gitignore
> 
> diff --git a/tools/perf/config/feature-checks/.gitignore b/tools/perf/config/feature-checks/.gitignore
> new file mode 100644
> index 0000000..6f92dcd
> --- /dev/null
> +++ b/tools/perf/config/feature-checks/.gitignore
> @@ -0,0 +1,43 @@
> +test-all.d
> +test-backtrace
> +test-backtrace.d
> +test-dwarf
> +test-dwarf.d
> +test-fortify-source
> +test-fortify-source.d
> +test-glibc
> +test-glibc.d
> +test-gtk2
> +test-gtk2-infobar
> +test-gtk2-infobar.d
> +test-gtk2.d
> +test-libaudit
> +test-libaudit.d
> +test-libbfd
> +test-libbfd.d
> +test-libelf
> +test-libelf-getphdrnum
> +test-libelf-getphdrnum.d
> +test-libelf-mmap
> +test-libelf-mmap.d
> +test-libelf.d
> +test-libnuma
> +test-libnuma.d
> +test-libperl.d
> +test-libpython
> +test-libpython-version
> +test-libpython-version.d
> +test-libpython.d
> +test-libslang
> +test-libslang.d
> +test-libunwind
> +test-libunwind.d
> +test-on-exit
> +test-on-exit.d
> +test-stackprotector
> +test-stackprotector-all
> +test-stackprotector-all.d
> +test-stackprotector.d
> +test-timerfd
> +test-timerfd.d
> +
> -- 
> 1.8.5.1.109.g3d252a9
