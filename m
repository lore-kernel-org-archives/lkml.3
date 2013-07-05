Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757648Ab3GEUpa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 16:45:30 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:40285 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752374Ab3GEUp2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 16:45:28 -0400
Message-ID: <51D73062.2060508@gmail.com>
Date: Fri, 05 Jul 2013 22:45:22 +0200
From: Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:11.0) Gecko/20120412 Thunderbird/11.0.1
MIME-Version: 1.0
To: Mauro Carvalho Chehab <mchehab@redhat.com>
CC: linux-kernel@vger.kernel.org,
        Linux Media Mailing List <linux-media@vger.kernel.org>,
        "'Mauro Carvalho Chehab'" <mchehab@infradead.org>
Subject: Re: [PATCH] Update email to m.chehab@samsung.com
References: <1373033892-2507-1-git-send-email-mchehab@redhat.com>
In-Reply-To: <1373033892-2507-1-git-send-email-mchehab@redhat.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/05/2013 04:18 PM, Mauro Carvalho Chehab wrote:
> The email mchehab@redhat.com is no longer valid. Move it to
> m.chehab@samsung.com.
>
> Signed-off-by: Mauro Carvalho Chehab<mchehab@redhat.com>
> ---

Mauro,

it seems these changes are incorrect and don't belong to this patch:

>   .../arm/Samsung/clksrc-change-registers.awk        |  0
>   Documentation/devicetree/bindings/mfd/tps6507x.txt |  0
>   Documentation/dvb/get_dvb_firmware                 |  0

>   Documentation/target/tcm_mod_builder.py            |  0
>   Documentation/video4linux/extract_xc3028.pl        |  0

>   arch/arm64/kernel/vdso/gen_vdso_offsets.sh         |  0
>   arch/ia64/scripts/check-gas                        |  0
>   arch/ia64/scripts/toolchain-flags                  |  0
>   arch/powerpc/boot/wrapper                          |  0
>   arch/powerpc/relocs_check.pl                       |  0
>   arch/x86/vdso/checkundef.sh                        |  0

>   drivers/staging/usbip/userspace/autogen.sh         |  0
>   drivers/staging/usbip/userspace/cleanup.sh         |  0

>   lib/build_OID_registry                             |  0
>   scripts/Lindent                                    |  0
>   scripts/bloat-o-meter                              |  0
>   scripts/checkincludes.pl                           |  0
>   scripts/checkkconfigsymbols.sh                     |  0
>   scripts/checkpatch.pl                              |  0
>   scripts/checkstack.pl                              |  0
>   scripts/checksyscalls.sh                           |  0
>   scripts/checkversion.pl                            |  0
>   scripts/cleanfile                                  |  0
>   scripts/cleanpatch                                 |  0
>   scripts/coccicheck                                 |  0
>   scripts/config                                     |  0
>   scripts/decodecode                                 |  0
>   scripts/depmod.sh                                  |  0
>   scripts/diffconfig                                 |  0
>   scripts/extract-ikconfig                           |  0
>   scripts/extract-vmlinux                            |  0
>   scripts/get_maintainer.pl                          |  0
>   scripts/gfp-translate                              |  0
>   scripts/headerdep.pl                               |  0
>   scripts/headers.sh                                 |  0
>   scripts/kconfig/check.sh                           |  0
>   scripts/kconfig/merge_config.sh                    |  0
>   scripts/kernel-doc                                 |  0
>   scripts/makelst                                    |  0
>   scripts/mkcompile_h                                |  0
>   scripts/mkuboot.sh                                 |  0
>   scripts/namespace.pl                               |  0
>   scripts/package/mkspec                             |  0
>   scripts/patch-kernel                               |  0
>   scripts/recordmcount.pl                            |  0
>   scripts/setlocalversion                            |  0
>   scripts/show_delta                                 |  0
>   scripts/sign-file                                  |  0
>   scripts/tags.sh                                    |  0
>   scripts/ver_linux                                  |  0
>   tools/hv/hv_get_dhcp_info.sh                       |  0
>   tools/hv/hv_get_dns_info.sh                        |  0
>   tools/hv/hv_set_ifconfig.sh                        |  0
>   tools/nfsd/inject_fault.sh                         |  0
>   tools/perf/python/twatch.py                        |  0
>   .../Perf-Trace-Util/lib/Perf/Trace/EventClass.py   |  0
>   .../perf/scripts/python/bin/net_dropmonitor-record |  0
>   .../perf/scripts/python/bin/net_dropmonitor-report |  0
>   tools/perf/scripts/python/net_dropmonitor.py       |  0
>   tools/perf/util/PERF-VERSION-GEN                   |  0
>   tools/perf/util/generate-cmdlist.sh                |  0
>   tools/power/cpupower/utils/version-gen.sh          |  0
>   tools/testing/ktest/compare-ktest-sample.pl        |  0
>   tools/testing/ktest/ktest.pl                       |  0
>   169 files changed, 209 insertions(+), 209 deletions(-)
>   mode change 100755 =>  100644 Documentation/arm/Samsung/clksrc-change-registers.awk
>   mode change 100755 =>  100644 Documentation/devicetree/bindings/mfd/tps6507x.txt
>   mode change 100755 =>  100644 Documentation/dvb/get_dvb_firmware
>   mode change 100755 =>  100644 Documentation/target/tcm_mod_builder.py
>   mode change 100755 =>  100644 Documentation/video4linux/extract_xc3028.pl
>   mode change 100755 =>  100644 arch/arm64/kernel/vdso/gen_vdso_offsets.sh
>   mode change 100755 =>  100644 arch/ia64/scripts/check-gas
>   mode change 100755 =>  100644 arch/ia64/scripts/toolchain-flags
>   mode change 100755 =>  100644 arch/powerpc/boot/wrapper
>   mode change 100755 =>  100644 arch/powerpc/relocs_check.pl
>   mode change 100755 =>  100644 arch/x86/vdso/checkundef.sh
>   mode change 100755 =>  100644 drivers/staging/usbip/userspace/autogen.sh
>   mode change 100755 =>  100644 drivers/staging/usbip/userspace/cleanup.sh
>   mode change 100755 =>  100644 lib/build_OID_registry
>   mode change 100755 =>  100644 scripts/Lindent
>   mode change 100755 =>  100644 scripts/bloat-o-meter
>   mode change 100755 =>  100644 scripts/checkincludes.pl
>   mode change 100755 =>  100644 scripts/checkkconfigsymbols.sh
>   mode change 100755 =>  100644 scripts/checkpatch.pl
>   mode change 100755 =>  100644 scripts/checkstack.pl
>   mode change 100755 =>  100644 scripts/checksyscalls.sh
>   mode change 100755 =>  100644 scripts/checkversion.pl
>   mode change 100755 =>  100644 scripts/cleanfile
>   mode change 100755 =>  100644 scripts/cleanpatch
>   mode change 100755 =>  100644 scripts/coccicheck
>   mode change 100755 =>  100644 scripts/config
>   mode change 100755 =>  100644 scripts/decodecode
>   mode change 100755 =>  100644 scripts/depmod.sh
>   mode change 100755 =>  100644 scripts/diffconfig
>   mode change 100755 =>  100644 scripts/extract-ikconfig
>   mode change 100755 =>  100644 scripts/extract-vmlinux
>   mode change 100755 =>  100644 scripts/get_maintainer.pl
>   mode change 100755 =>  100644 scripts/gfp-translate
>   mode change 100755 =>  100644 scripts/headerdep.pl
>   mode change 100755 =>  100644 scripts/headers.sh
>   mode change 100755 =>  100644 scripts/kconfig/check.sh
>   mode change 100755 =>  100644 scripts/kconfig/merge_config.sh
>   mode change 100755 =>  100644 scripts/kernel-doc
>   mode change 100755 =>  100644 scripts/makelst
>   mode change 100755 =>  100644 scripts/mkcompile_h
>   mode change 100755 =>  100644 scripts/mkuboot.sh
>   mode change 100755 =>  100644 scripts/namespace.pl
>   mode change 100755 =>  100644 scripts/package/mkspec
>   mode change 100755 =>  100644 scripts/patch-kernel
>   mode change 100755 =>  100644 scripts/recordmcount.pl
>   mode change 100755 =>  100644 scripts/setlocalversion
>   mode change 100755 =>  100644 scripts/show_delta
>   mode change 100755 =>  100644 scripts/sign-file
>   mode change 100755 =>  100644 scripts/tags.sh
>   mode change 100755 =>  100644 scripts/ver_linux
>   mode change 100755 =>  100644 tools/hv/hv_get_dhcp_info.sh
>   mode change 100755 =>  100644 tools/hv/hv_get_dns_info.sh
>   mode change 100755 =>  100644 tools/hv/hv_set_ifconfig.sh
>   mode change 100755 =>  100644 tools/nfsd/inject_fault.sh
>   mode change 100755 =>  100644 tools/perf/python/twatch.py
>   mode change 100755 =>  100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
>   mode change 100755 =>  100644 tools/perf/scripts/python/bin/net_dropmonitor-record
>   mode change 100755 =>  100644 tools/perf/scripts/python/bin/net_dropmonitor-report
>   mode change 100755 =>  100644 tools/perf/scripts/python/net_dropmonitor.py
>   mode change 100755 =>  100644 tools/perf/util/PERF-VERSION-GEN
>   mode change 100755 =>  100644 tools/perf/util/generate-cmdlist.sh
>   mode change 100755 =>  100644 tools/power/cpupower/utils/version-gen.sh
>   mode change 100755 =>  100644 tools/testing/ktest/compare-ktest-sample.pl
>   mode change 100755 =>  100644 tools/testing/ktest/ktest.pl


> diff --git a/lib/build_OID_registry b/lib/build_OID_registry
> old mode 100755
> new mode 100644
> diff --git a/scripts/Lindent b/scripts/Lindent
> old mode 100755
> new mode 100644
> diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
> old mode 100755
> new mode 100644
> diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
> old mode 100755
> new mode 100644
> diff --git a/scripts/checkkconfigsymbols.sh b/scripts/checkkconfigsymbols.sh
> old mode 100755
> new mode 100644
> diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
> old mode 100755
> new mode 100644
> diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
> old mode 100755
> new mode 100644
> diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
> old mode 100755
> new mode 100644
> diff --git a/scripts/checkversion.pl b/scripts/checkversion.pl
> old mode 100755
> new mode 100644
> diff --git a/scripts/cleanfile b/scripts/cleanfile
> old mode 100755
> new mode 100644
> diff --git a/scripts/cleanpatch b/scripts/cleanpatch
> old mode 100755
> new mode 100644
> diff --git a/scripts/coccicheck b/scripts/coccicheck
> old mode 100755
> new mode 100644
> diff --git a/scripts/config b/scripts/config
> old mode 100755
> new mode 100644
> diff --git a/scripts/decodecode b/scripts/decodecode
> old mode 100755
> new mode 100644
> diff --git a/scripts/depmod.sh b/scripts/depmod.sh
> old mode 100755
> new mode 100644
> diff --git a/scripts/diffconfig b/scripts/diffconfig
> old mode 100755
> new mode 100644
> diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
> old mode 100755
> new mode 100644
> diff --git a/scripts/extract-vmlinux b/scripts/extract-vmlinux
> old mode 100755
> new mode 100644
> diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
> old mode 100755
> new mode 100644
> diff --git a/scripts/gfp-translate b/scripts/gfp-translate
> old mode 100755
> new mode 100644
> diff --git a/scripts/headerdep.pl b/scripts/headerdep.pl
> old mode 100755
> new mode 100644
> diff --git a/scripts/headers.sh b/scripts/headers.sh
> old mode 100755
> new mode 100644
> diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
> old mode 100755
> new mode 100644
> diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
> old mode 100755
> new mode 100644
> diff --git a/scripts/kernel-doc b/scripts/kernel-doc
> old mode 100755
> new mode 100644
> diff --git a/scripts/makelst b/scripts/makelst
> old mode 100755
> new mode 100644
> diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
> old mode 100755
> new mode 100644
> diff --git a/scripts/mkuboot.sh b/scripts/mkuboot.sh
> old mode 100755
> new mode 100644
> diff --git a/scripts/namespace.pl b/scripts/namespace.pl
> old mode 100755
> new mode 100644
> diff --git a/scripts/package/mkspec b/scripts/package/mkspec
> old mode 100755
> new mode 100644
> diff --git a/scripts/patch-kernel b/scripts/patch-kernel
> old mode 100755
> new mode 100644
> diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
> old mode 100755
> new mode 100644
> diff --git a/scripts/setlocalversion b/scripts/setlocalversion
> old mode 100755
> new mode 100644
> diff --git a/scripts/show_delta b/scripts/show_delta
> old mode 100755
> new mode 100644
> diff --git a/scripts/sign-file b/scripts/sign-file
> old mode 100755
> new mode 100644
> diff --git a/scripts/tags.sh b/scripts/tags.sh
> old mode 100755
> new mode 100644
> diff --git a/scripts/ver_linux b/scripts/ver_linux
> old mode 100755
> new mode 100644
> diff --git a/tools/hv/hv_get_dhcp_info.sh b/tools/hv/hv_get_dhcp_info.sh
> old mode 100755
> new mode 100644
> diff --git a/tools/hv/hv_get_dns_info.sh b/tools/hv/hv_get_dns_info.sh
> old mode 100755
> new mode 100644
> diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
> old mode 100755
> new mode 100644
> diff --git a/tools/nfsd/inject_fault.sh b/tools/nfsd/inject_fault.sh
> old mode 100755
> new mode 100644
> diff --git a/tools/perf/python/twatch.py b/tools/perf/python/twatch.py
> old mode 100755
> new mode 100644
> diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
> old mode 100755
> new mode 100644
> diff --git a/tools/perf/scripts/python/bin/net_dropmonitor-record b/tools/perf/scripts/python/bin/net_dropmonitor-record
> old mode 100755
> new mode 100644
> diff --git a/tools/perf/scripts/python/bin/net_dropmonitor-report b/tools/perf/scripts/python/bin/net_dropmonitor-report
> old mode 100755
> new mode 100644
> diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
> old mode 100755
> new mode 100644
> diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
> old mode 100755
> new mode 100644
> diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
> old mode 100755
> new mode 100644
> diff --git a/tools/power/cpupower/utils/version-gen.sh b/tools/power/cpupower/utils/version-gen.sh
> old mode 100755
> new mode 100644
> diff --git a/tools/testing/ktest/compare-ktest-sample.pl b/tools/testing/ktest/compare-ktest-sample.pl
> old mode 100755
> new mode 100644
> diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
> old mode 100755
> new mode 100644

Regards,
Sylwester
