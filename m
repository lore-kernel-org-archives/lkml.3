Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757653Ab3GEUfM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:35:12 -0400
Received: from canardo.mork.no ([148.122.252.1]:42439 "EHLO canardo.mork.no"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757481Ab3GEUfL convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:35:11 -0400
From: =?utf-8?Q?Bj=C3=B8rn_Mork?= <bjorn@mork.no>
To: Mauro Carvalho Chehab <mchehab@infradead.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Stephen Rothwell <sfr@canb.auug.org.au>,
        Manu Abraham <abraham.manu@gmail.com>
Subject: Re: [GIT PULL for v3.11-rc1] media patches for v3.11
Organization: m
References: <20130705114028.7b431587@infradead.org>
Date: Fri, 05 Jul 2013 22:34:16 +0200
In-Reply-To: <20130705114028.7b431587@infradead.org> (Mauro Carvalho Chehab's
	message of "Fri, 5 Jul 2013 11:40:28 -0300")
Message-ID: <878v1kiw53.fsf@nemi.mork.no>
User-Agent: Gnus/5.11002 (No Gnus v0.20) Emacs/23.4 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mauro Carvalho Chehab <mchehab@infradead.org> writes:

>  mode change 100755 => 100644 lib/build_OID_registry
>  mode change 100755 => 100644 scripts/Lindent
>  mode change 100755 => 100644 scripts/bloat-o-meter
>  mode change 100755 => 100644 scripts/checkincludes.pl
>  mode change 100755 => 100644 scripts/checkkconfigsymbols.sh
>  mode change 100755 => 100644 scripts/checkpatch.pl
>  mode change 100755 => 100644 scripts/checkstack.pl
>  mode change 100755 => 100644 scripts/checksyscalls.sh
>  mode change 100755 => 100644 scripts/checkversion.pl
>  mode change 100755 => 100644 scripts/cleanfile
>  mode change 100755 => 100644 scripts/cleanpatch
>  mode change 100755 => 100644 scripts/coccicheck
>  mode change 100755 => 100644 scripts/config
>  mode change 100755 => 100644 scripts/decodecode
>  mode change 100755 => 100644 scripts/depmod.sh
>  mode change 100755 => 100644 scripts/diffconfig
>  mode change 100755 => 100644 scripts/extract-ikconfig
>  mode change 100755 => 100644 scripts/extract-vmlinux
>  mode change 100755 => 100644 scripts/get_maintainer.pl
>  mode change 100755 => 100644 scripts/gfp-translate
>  mode change 100755 => 100644 scripts/headerdep.pl
>  mode change 100755 => 100644 scripts/headers.sh
>  mode change 100755 => 100644 scripts/kconfig/check.sh
>  mode change 100755 => 100644 scripts/kconfig/merge_config.sh
>  mode change 100755 => 100644 scripts/kernel-doc
>  mode change 100755 => 100644 scripts/makelst
>  mode change 100755 => 100644 scripts/mkcompile_h
>  mode change 100755 => 100644 scripts/mkuboot.sh
>  mode change 100755 => 100644 scripts/namespace.pl
>  mode change 100755 => 100644 scripts/package/mkspec
>  mode change 100755 => 100644 scripts/patch-kernel
>  mode change 100755 => 100644 scripts/recordmcount.pl
>  mode change 100755 => 100644 scripts/setlocalversion
>  mode change 100755 => 100644 scripts/show_delta
>  mode change 100755 => 100644 scripts/sign-file
>  mode change 100755 => 100644 scripts/tags.sh
>  mode change 100755 => 100644 scripts/ver_linux
>  mode change 100755 => 100644 tools/hv/hv_get_dhcp_info.sh
>  mode change 100755 => 100644 tools/hv/hv_get_dns_info.sh
>  mode change 100755 => 100644 tools/hv/hv_set_ifconfig.sh
>  mode change 100755 => 100644 tools/nfsd/inject_fault.sh
>  mode change 100755 => 100644 tools/perf/python/twatch.py
>  mode change 100755 => 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
>  mode change 100755 => 100644 tools/perf/scripts/python/bin/net_dropmonitor-record
>  mode change 100755 => 100644 tools/perf/scripts/python/bin/net_dropmonitor-report
>  mode change 100755 => 100644 tools/perf/scripts/python/net_dropmonitor.py
>  mode change 100755 => 100644 tools/perf/util/PERF-VERSION-GEN
>  mode change 100755 => 100644 tools/perf/util/generate-cmdlist.sh
>  mode change 100755 => 100644 tools/power/cpupower/utils/version-gen.sh
>  mode change 100755 => 100644 tools/testing/ktest/compare-ktest-sample.pl
>  mode change 100755 => 100644 tools/testing/ktest/ktest.pl


You didn't really mean to do that, did you?



Bjørn
