Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933813Ab3GEOSo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 10:18:44 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:40622 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756251Ab3GEOSl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 10:18:41 -0400
From: Mauro Carvalho Chehab <mchehab@redhat.com>
Cc: linux-kernel@vger.kernel.org, Mauro Carvalho Chehab <mchehab@redhat.com>,
        Linux Media Mailing List <linux-media@vger.kernel.org>
Subject: [PATCH] Update email to m.chehab@samsung.com
Date: Fri,  5 Jul 2013 11:18:12 -0300
Message-Id: <1373033892-2507-1-git-send-email-mchehab@redhat.com>
X-Mailer: git-send-email 1.8.3.1
X-SRS-Rewrite: SMTP reverse-path rewritten from <mchehab@infradead.org> by bombadil.infradead.org
	See http://www.infradead.org/rpr.html
To: unlisted-recipients:; (no To-header on input)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The email mchehab@redhat.com is no longer valid. Move it to
m.chehab@samsung.com.

Signed-off-by: Mauro Carvalho Chehab <mchehab@redhat.com>
---
 Documentation/ABI/testing/sysfs-devices-edac       | 14 +++++-----
 Documentation/DocBook/media/dvb/dvbapi.xml         |  2 +-
 Documentation/DocBook/media/v4l/v4l2.xml           |  2 +-
 Documentation/DocBook/media_api.tmpl               |  2 +-
 .../arm/Samsung/clksrc-change-registers.awk        |  0
 Documentation/devicetree/bindings/mfd/tps6507x.txt |  0
 Documentation/dvb/get_dvb_firmware                 |  0
 Documentation/edac.txt                             |  2 +-
 Documentation/target/tcm_mod_builder.py            |  0
 Documentation/video4linux/extract_xc3028.pl        |  0
 MAINTAINERS                                        | 32 +++++++++++-----------
 arch/arm64/kernel/vdso/gen_vdso_offsets.sh         |  0
 arch/ia64/scripts/check-gas                        |  0
 arch/ia64/scripts/toolchain-flags                  |  0
 arch/powerpc/boot/wrapper                          |  0
 arch/powerpc/relocs_check.pl                       |  0
 arch/x86/vdso/checkundef.sh                        |  0
 drivers/edac/edac_mc_sysfs.c                       |  2 +-
 drivers/edac/ghes_edac.c                           |  2 +-
 drivers/edac/i5400_edac.c                          |  4 +--
 drivers/edac/i7300_edac.c                          |  4 +--
 drivers/edac/i7core_edac.c                         |  4 +--
 drivers/edac/sb_edac.c                             |  4 +--
 drivers/media/common/siano/smsdvb-debugfs.c        |  2 +-
 drivers/media/dvb-frontends/mb86a20s.c             |  4 +--
 drivers/media/dvb-frontends/mb86a20s.h             |  2 +-
 drivers/media/dvb-frontends/s921.c                 |  4 +--
 drivers/media/dvb-frontends/s921.h                 |  2 +-
 drivers/media/i2c/mt9v011.c                        |  4 +--
 drivers/media/i2c/sr030pc30.c                      |  2 +-
 drivers/media/rc/ir-nec-decoder.c                  |  4 +--
 drivers/media/rc/ir-raw.c                          |  2 +-
 drivers/media/rc/ir-rc5-decoder.c                  |  4 +--
 drivers/media/rc/ir-rc5-sz-decoder.c               |  2 +-
 drivers/media/rc/ir-sanyo-decoder.c                |  4 +--
 drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c    |  4 +--
 drivers/media/rc/keymaps/rc-apac-viewcomp.c        |  4 +--
 drivers/media/rc/keymaps/rc-asus-pc39.c            |  4 +--
 drivers/media/rc/keymaps/rc-asus-ps3-100.c         |  4 +--
 drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c |  4 +--
 drivers/media/rc/keymaps/rc-avermedia-a16d.c       |  4 +--
 drivers/media/rc/keymaps/rc-avermedia-cardbus.c    |  4 +--
 drivers/media/rc/keymaps/rc-avermedia-dvbt.c       |  4 +--
 drivers/media/rc/keymaps/rc-avermedia-m135a.c      |  4 +--
 .../media/rc/keymaps/rc-avermedia-m733a-rm-k6.c    |  2 +-
 drivers/media/rc/keymaps/rc-avermedia.c            |  4 +--
 drivers/media/rc/keymaps/rc-avertv-303.c           |  4 +--
 drivers/media/rc/keymaps/rc-behold-columbus.c      |  4 +--
 drivers/media/rc/keymaps/rc-behold.c               |  4 +--
 drivers/media/rc/keymaps/rc-budget-ci-old.c        |  4 +--
 drivers/media/rc/keymaps/rc-cinergy-1400.c         |  4 +--
 drivers/media/rc/keymaps/rc-cinergy.c              |  4 +--
 drivers/media/rc/keymaps/rc-dib0700-nec.c          |  4 +--
 drivers/media/rc/keymaps/rc-dib0700-rc5.c          |  4 +--
 drivers/media/rc/keymaps/rc-dm1105-nec.c           |  4 +--
 drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c      |  4 +--
 drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c   |  4 +--
 drivers/media/rc/keymaps/rc-em-terratec.c          |  4 +--
 drivers/media/rc/keymaps/rc-encore-enltv-fm53.c    |  4 +--
 drivers/media/rc/keymaps/rc-encore-enltv.c         |  4 +--
 drivers/media/rc/keymaps/rc-encore-enltv2.c        |  4 +--
 drivers/media/rc/keymaps/rc-evga-indtube.c         |  4 +--
 drivers/media/rc/keymaps/rc-eztv.c                 |  4 +--
 drivers/media/rc/keymaps/rc-flydvb.c               |  4 +--
 drivers/media/rc/keymaps/rc-flyvideo.c             |  4 +--
 drivers/media/rc/keymaps/rc-fusionhdtv-mce.c       |  4 +--
 drivers/media/rc/keymaps/rc-gadmei-rm008z.c        |  4 +--
 drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c   |  4 +--
 drivers/media/rc/keymaps/rc-gotview7135.c          |  4 +--
 drivers/media/rc/keymaps/rc-hauppauge.c            |  4 +--
 drivers/media/rc/keymaps/rc-iodata-bctv7e.c        |  4 +--
 drivers/media/rc/keymaps/rc-kaiomy.c               |  4 +--
 drivers/media/rc/keymaps/rc-kworld-315u.c          |  4 +--
 drivers/media/rc/keymaps/rc-kworld-pc150u.c        |  2 +-
 .../media/rc/keymaps/rc-kworld-plus-tv-analog.c    |  4 +--
 drivers/media/rc/keymaps/rc-manli.c                |  4 +--
 drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c  |  4 +--
 drivers/media/rc/keymaps/rc-msi-tvanywhere.c       |  4 +--
 drivers/media/rc/keymaps/rc-nebula.c               |  4 +--
 .../media/rc/keymaps/rc-nec-terratec-cinergy-xs.c  |  6 ++--
 drivers/media/rc/keymaps/rc-norwood.c              |  4 +--
 drivers/media/rc/keymaps/rc-npgtech.c              |  4 +--
 drivers/media/rc/keymaps/rc-pctv-sedna.c           |  4 +--
 drivers/media/rc/keymaps/rc-pinnacle-color.c       |  4 +--
 drivers/media/rc/keymaps/rc-pinnacle-grey.c        |  4 +--
 drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c     |  4 +--
 drivers/media/rc/keymaps/rc-pixelview-002t.c       |  4 +--
 drivers/media/rc/keymaps/rc-pixelview-mk12.c       |  4 +--
 drivers/media/rc/keymaps/rc-pixelview-new.c        |  4 +--
 drivers/media/rc/keymaps/rc-pixelview.c            |  4 +--
 .../media/rc/keymaps/rc-powercolor-real-angel.c    |  4 +--
 drivers/media/rc/keymaps/rc-proteus-2309.c         |  4 +--
 drivers/media/rc/keymaps/rc-purpletv.c             |  4 +--
 drivers/media/rc/keymaps/rc-pv951.c                |  4 +--
 .../media/rc/keymaps/rc-real-audio-220-32-keys.c   |  4 +--
 drivers/media/rc/keymaps/rc-tbs-nec.c              |  4 +--
 drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c  |  4 +--
 drivers/media/rc/keymaps/rc-tevii-nec.c            |  4 +--
 drivers/media/rc/keymaps/rc-tt-1500.c              |  4 +--
 drivers/media/rc/keymaps/rc-videomate-s350.c       |  4 +--
 drivers/media/rc/keymaps/rc-videomate-tv-pvr.c     |  4 +--
 drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c |  4 +--
 drivers/media/rc/keymaps/rc-winfast.c              |  4 +--
 drivers/media/rc/rc-core-priv.h                    |  2 +-
 drivers/media/rc/rc-main.c                         |  4 +--
 drivers/media/tuners/mt2063.c                      |  4 +--
 drivers/media/tuners/r820t.c                       |  4 +--
 drivers/media/usb/cx231xx/cx231xx-input.c          |  2 +-
 drivers/media/usb/dvb-usb-v2/az6007.c              |  4 +--
 drivers/media/usb/em28xx/em28xx-audio.c            |  4 +--
 drivers/media/usb/em28xx/em28xx-input.c            |  2 +-
 drivers/media/usb/tm6000/tm6000-alsa.c             |  4 +--
 drivers/media/usb/tm6000/tm6000-dvb.c              |  2 +-
 drivers/media/usb/tm6000/tm6000-stds.c             |  2 +-
 drivers/staging/usbip/userspace/autogen.sh         |  0
 drivers/staging/usbip/userspace/cleanup.sh         |  0
 include/media/rc-core.h                            |  2 +-
 include/media/rc-map.h                             |  2 +-
 lib/build_OID_registry                             |  0
 scripts/Lindent                                    |  0
 scripts/bloat-o-meter                              |  0
 scripts/checkincludes.pl                           |  0
 scripts/checkkconfigsymbols.sh                     |  0
 scripts/checkpatch.pl                              |  0
 scripts/checkstack.pl                              |  0
 scripts/checksyscalls.sh                           |  0
 scripts/checkversion.pl                            |  0
 scripts/cleanfile                                  |  0
 scripts/cleanpatch                                 |  0
 scripts/coccicheck                                 |  0
 scripts/config                                     |  0
 scripts/decodecode                                 |  0
 scripts/depmod.sh                                  |  0
 scripts/diffconfig                                 |  0
 scripts/extract-ikconfig                           |  0
 scripts/extract-vmlinux                            |  0
 scripts/get_maintainer.pl                          |  0
 scripts/gfp-translate                              |  0
 scripts/headerdep.pl                               |  0
 scripts/headers.sh                                 |  0
 scripts/kconfig/check.sh                           |  0
 scripts/kconfig/merge_config.sh                    |  0
 scripts/kernel-doc                                 |  0
 scripts/makelst                                    |  0
 scripts/mkcompile_h                                |  0
 scripts/mkuboot.sh                                 |  0
 scripts/namespace.pl                               |  0
 scripts/package/mkspec                             |  0
 scripts/patch-kernel                               |  0
 scripts/recordmcount.pl                            |  0
 scripts/setlocalversion                            |  0
 scripts/show_delta                                 |  0
 scripts/sign-file                                  |  0
 scripts/tags.sh                                    |  0
 scripts/ver_linux                                  |  0
 tools/hv/hv_get_dhcp_info.sh                       |  0
 tools/hv/hv_get_dns_info.sh                        |  0
 tools/hv/hv_set_ifconfig.sh                        |  0
 tools/nfsd/inject_fault.sh                         |  0
 tools/perf/python/twatch.py                        |  0
 .../Perf-Trace-Util/lib/Perf/Trace/EventClass.py   |  0
 .../perf/scripts/python/bin/net_dropmonitor-record |  0
 .../perf/scripts/python/bin/net_dropmonitor-report |  0
 tools/perf/scripts/python/net_dropmonitor.py       |  0
 tools/perf/util/PERF-VERSION-GEN                   |  0
 tools/perf/util/generate-cmdlist.sh                |  0
 tools/power/cpupower/utils/version-gen.sh          |  0
 tools/testing/ktest/compare-ktest-sample.pl        |  0
 tools/testing/ktest/ktest.pl                       |  0
 169 files changed, 209 insertions(+), 209 deletions(-)
 mode change 100755 => 100644 Documentation/arm/Samsung/clksrc-change-registers.awk
 mode change 100755 => 100644 Documentation/devicetree/bindings/mfd/tps6507x.txt
 mode change 100755 => 100644 Documentation/dvb/get_dvb_firmware
 mode change 100755 => 100644 Documentation/target/tcm_mod_builder.py
 mode change 100755 => 100644 Documentation/video4linux/extract_xc3028.pl
 mode change 100755 => 100644 arch/arm64/kernel/vdso/gen_vdso_offsets.sh
 mode change 100755 => 100644 arch/ia64/scripts/check-gas
 mode change 100755 => 100644 arch/ia64/scripts/toolchain-flags
 mode change 100755 => 100644 arch/powerpc/boot/wrapper
 mode change 100755 => 100644 arch/powerpc/relocs_check.pl
 mode change 100755 => 100644 arch/x86/vdso/checkundef.sh
 mode change 100755 => 100644 drivers/staging/usbip/userspace/autogen.sh
 mode change 100755 => 100644 drivers/staging/usbip/userspace/cleanup.sh
 mode change 100755 => 100644 lib/build_OID_registry
 mode change 100755 => 100644 scripts/Lindent
 mode change 100755 => 100644 scripts/bloat-o-meter
 mode change 100755 => 100644 scripts/checkincludes.pl
 mode change 100755 => 100644 scripts/checkkconfigsymbols.sh
 mode change 100755 => 100644 scripts/checkpatch.pl
 mode change 100755 => 100644 scripts/checkstack.pl
 mode change 100755 => 100644 scripts/checksyscalls.sh
 mode change 100755 => 100644 scripts/checkversion.pl
 mode change 100755 => 100644 scripts/cleanfile
 mode change 100755 => 100644 scripts/cleanpatch
 mode change 100755 => 100644 scripts/coccicheck
 mode change 100755 => 100644 scripts/config
 mode change 100755 => 100644 scripts/decodecode
 mode change 100755 => 100644 scripts/depmod.sh
 mode change 100755 => 100644 scripts/diffconfig
 mode change 100755 => 100644 scripts/extract-ikconfig
 mode change 100755 => 100644 scripts/extract-vmlinux
 mode change 100755 => 100644 scripts/get_maintainer.pl
 mode change 100755 => 100644 scripts/gfp-translate
 mode change 100755 => 100644 scripts/headerdep.pl
 mode change 100755 => 100644 scripts/headers.sh
 mode change 100755 => 100644 scripts/kconfig/check.sh
 mode change 100755 => 100644 scripts/kconfig/merge_config.sh
 mode change 100755 => 100644 scripts/kernel-doc
 mode change 100755 => 100644 scripts/makelst
 mode change 100755 => 100644 scripts/mkcompile_h
 mode change 100755 => 100644 scripts/mkuboot.sh
 mode change 100755 => 100644 scripts/namespace.pl
 mode change 100755 => 100644 scripts/package/mkspec
 mode change 100755 => 100644 scripts/patch-kernel
 mode change 100755 => 100644 scripts/recordmcount.pl
 mode change 100755 => 100644 scripts/setlocalversion
 mode change 100755 => 100644 scripts/show_delta
 mode change 100755 => 100644 scripts/sign-file
 mode change 100755 => 100644 scripts/tags.sh
 mode change 100755 => 100644 scripts/ver_linux
 mode change 100755 => 100644 tools/hv/hv_get_dhcp_info.sh
 mode change 100755 => 100644 tools/hv/hv_get_dns_info.sh
 mode change 100755 => 100644 tools/hv/hv_set_ifconfig.sh
 mode change 100755 => 100644 tools/nfsd/inject_fault.sh
 mode change 100755 => 100644 tools/perf/python/twatch.py
 mode change 100755 => 100644 tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
 mode change 100755 => 100644 tools/perf/scripts/python/bin/net_dropmonitor-record
 mode change 100755 => 100644 tools/perf/scripts/python/bin/net_dropmonitor-report
 mode change 100755 => 100644 tools/perf/scripts/python/net_dropmonitor.py
 mode change 100755 => 100644 tools/perf/util/PERF-VERSION-GEN
 mode change 100755 => 100644 tools/perf/util/generate-cmdlist.sh
 mode change 100755 => 100644 tools/power/cpupower/utils/version-gen.sh
 mode change 100755 => 100644 tools/testing/ktest/compare-ktest-sample.pl
 mode change 100755 => 100644 tools/testing/ktest/ktest.pl

diff --git a/Documentation/ABI/testing/sysfs-devices-edac b/Documentation/ABI/testing/sysfs-devices-edac
index 30ee78a..6568e00 100644
--- a/Documentation/ABI/testing/sysfs-devices-edac
+++ b/Documentation/ABI/testing/sysfs-devices-edac
@@ -77,7 +77,7 @@ Description:	Read/Write attribute file that controls memory scrubbing.
 
 What:		/sys/devices/system/edac/mc/mc*/max_location
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 		linux-edac@vger.kernel.org
 Description:	This attribute file displays the information about the last
 		available memory slot in this memory controller. It is used by
@@ -85,7 +85,7 @@ Description:	This attribute file displays the information about the last
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/size
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display the size of dimm or rank.
 		For dimm*/size, this is the size, in MB of the DIMM memory
@@ -96,14 +96,14 @@ Description:	This attribute file will display the size of dimm or rank.
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_dev_type
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display what type of DRAM device is
 		being utilized on this DIMM (x1, x2, x4, x8, ...).
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_edac_mode
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display what type of Error detection
 		and correction is being utilized. For example: S4ECD4ED would
@@ -111,7 +111,7 @@ Description:	This attribute file will display what type of Error detection
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_label
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 		linux-edac@vger.kernel.org
 Description:	This control file allows this DIMM to have a label assigned
 		to it. With this label in the module, when errors occur
@@ -126,14 +126,14 @@ Description:	This control file allows this DIMM to have a label assigned
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_location
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display the location (csrow/channel,
 		branch/channel/slot or channel/slot) of the dimm or rank.
 
 What:		/sys/devices/system/edac/mc/mc*/(dimm|rank)*/dimm_mem_type
 Date:		April 2012
-Contact:	Mauro Carvalho Chehab <mchehab@redhat.com>
+Contact:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 		linux-edac@vger.kernel.org
 Description:	This attribute file will display what type of memory is
 		currently on this csrow. Normally, either buffered or
diff --git a/Documentation/DocBook/media/dvb/dvbapi.xml b/Documentation/DocBook/media/dvb/dvbapi.xml
index 0197bcc..49f46e8 100644
--- a/Documentation/DocBook/media/dvb/dvbapi.xml
+++ b/Documentation/DocBook/media/dvb/dvbapi.xml
@@ -18,7 +18,7 @@
 <firstname>Mauro</firstname>
 <othername role="mi">Carvalho</othername>
 <surname>Chehab</surname>
-<affiliation><address><email>mchehab@redhat.com</email></address></affiliation>
+<affiliation><address><email>m.chehab@samsung.com</email></address></affiliation>
 <contrib>Ported document to Docbook XML.</contrib>
 </author>
 </authorgroup>
diff --git a/Documentation/DocBook/media/v4l/v4l2.xml b/Documentation/DocBook/media/v4l/v4l2.xml
index 8469fe1..53f5306 100644
--- a/Documentation/DocBook/media/v4l/v4l2.xml
+++ b/Documentation/DocBook/media/v4l/v4l2.xml
@@ -70,7 +70,7 @@ MPEG stream embedded, sliced VBI data format in this specification.
 Remote Controller chapter.</contrib>
 	<affiliation>
 	  <address>
-	    <email>mchehab@redhat.com</email>
+	    <email>m.chehab@samsung.com</email>
 	  </address>
 	</affiliation>
       </author>
diff --git a/Documentation/DocBook/media_api.tmpl b/Documentation/DocBook/media_api.tmpl
index 6a8b715..8afcc53 100644
--- a/Documentation/DocBook/media_api.tmpl
+++ b/Documentation/DocBook/media_api.tmpl
@@ -85,7 +85,7 @@ Foundation. A copy of the license is included in the chapter entitled
 <firstname>Mauro</firstname>
 <surname>Chehab</surname>
 <othername role="mi">Carvalho</othername>
-<affiliation><address><email>mchehab@redhat.com</email></address></affiliation>
+<affiliation><address><email>m.chehab@samsung.com</email></address></affiliation>
 <contrib>Initial version.</contrib>
 </author>
 </authorgroup>
diff --git a/Documentation/arm/Samsung/clksrc-change-registers.awk b/Documentation/arm/Samsung/clksrc-change-registers.awk
old mode 100755
new mode 100644
diff --git a/Documentation/devicetree/bindings/mfd/tps6507x.txt b/Documentation/devicetree/bindings/mfd/tps6507x.txt
old mode 100755
new mode 100644
diff --git a/Documentation/dvb/get_dvb_firmware b/Documentation/dvb/get_dvb_firmware
old mode 100755
new mode 100644
diff --git a/Documentation/edac.txt b/Documentation/edac.txt
index 56c7e93..7a964d6 100644
--- a/Documentation/edac.txt
+++ b/Documentation/edac.txt
@@ -6,7 +6,7 @@ Written by Doug Thompson <dougthompson@xmission.com>
 7 Dec 2005
 17 Jul 2007	Updated
 
-(c) Mauro Carvalho Chehab <mchehab@redhat.com>
+(c) Mauro Carvalho Chehab <m.chehab@samsung.com>
 05 Aug 2009	Nehalem interface
 
 EDAC is maintained and written by:
diff --git a/Documentation/target/tcm_mod_builder.py b/Documentation/target/tcm_mod_builder.py
old mode 100755
new mode 100644
diff --git a/Documentation/video4linux/extract_xc3028.pl b/Documentation/video4linux/extract_xc3028.pl
old mode 100755
new mode 100644
diff --git a/MAINTAINERS b/MAINTAINERS
index af77eb1..90644d1 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -1557,7 +1557,7 @@ F:	include/net/ax25.h
 F:	net/ax25/
 
 AZ6007 DVB DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -1841,7 +1841,7 @@ F:	Documentation/filesystems/btrfs.txt
 F:	fs/btrfs/
 
 BTTV VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -2312,7 +2312,7 @@ F:	drivers/media/common/cx2341x*
 F:	include/media/cx2341x*
 
 CX88 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -2930,7 +2930,7 @@ S:	Maintained
 F:	drivers/edac/e7xxx_edac.c
 
 EDAC-GHES
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
@@ -2958,21 +2958,21 @@ S:	Maintained
 F:	drivers/edac/i5000_edac.c
 
 EDAC-I5400
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i5400_edac.c
 
 EDAC-I7300
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i7300_edac.c
 
 EDAC-I7CORE
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
@@ -3001,7 +3001,7 @@ S:	Maintained
 F:	drivers/edac/r82600_edac.c
 
 EDAC-SBRIDGE
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-edac@vger.kernel.org
 W:	bluesmoke.sourceforge.net
 S:	Maintained
@@ -3061,7 +3061,7 @@ S:	Maintained
 F:	drivers/net/ethernet/ibm/ehea/
 
 EM28XX VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -5229,7 +5229,7 @@ S:	Maintained
 F:	drivers/media/radio/radio-maxiradio*
 
 MEDIA INPUT INFRASTRUCTURE (V4L/DVB)
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 P:	LinuxTV.org Project
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
@@ -6911,7 +6911,7 @@ S:	Odd Fixes
 F:	drivers/media/i2c/saa6588*
 
 SAA7134 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -7282,7 +7282,7 @@ S:	Odd Fixes
 F:	drivers/media/radio/radio-si4713.h
 
 SIANO DVB DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -7986,7 +7986,7 @@ S:	Maintained
 F:	drivers/media/i2c/tda9840*
 
 TEA5761 TUNER DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -7994,7 +7994,7 @@ S:	Odd fixes
 F:	drivers/media/tuners/tea5761.*
 
 TEA5767 TUNER DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -8232,7 +8232,7 @@ F:	include/linux/shmem_fs.h
 F:	mm/shmem.c
 
 TM6000 VIDEO4LINUX DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
@@ -9087,7 +9087,7 @@ S:	Maintained
 F:	arch/x86/kernel/cpu/mcheck/*
 
 XC2028/3028 TUNER DRIVER
-M:	Mauro Carvalho Chehab <mchehab@redhat.com>
+M:	Mauro Carvalho Chehab <m.chehab@samsung.com>
 L:	linux-media@vger.kernel.org
 W:	http://linuxtv.org
 T:	git git://linuxtv.org/media_tree.git
diff --git a/arch/arm64/kernel/vdso/gen_vdso_offsets.sh b/arch/arm64/kernel/vdso/gen_vdso_offsets.sh
old mode 100755
new mode 100644
diff --git a/arch/ia64/scripts/check-gas b/arch/ia64/scripts/check-gas
old mode 100755
new mode 100644
diff --git a/arch/ia64/scripts/toolchain-flags b/arch/ia64/scripts/toolchain-flags
old mode 100755
new mode 100644
diff --git a/arch/powerpc/boot/wrapper b/arch/powerpc/boot/wrapper
old mode 100755
new mode 100644
diff --git a/arch/powerpc/relocs_check.pl b/arch/powerpc/relocs_check.pl
old mode 100755
new mode 100644
diff --git a/arch/x86/vdso/checkundef.sh b/arch/x86/vdso/checkundef.sh
old mode 100755
new mode 100644
diff --git a/drivers/edac/edac_mc_sysfs.c b/drivers/edac/edac_mc_sysfs.c
index 67610a6..421153d 100644
--- a/drivers/edac/edac_mc_sysfs.c
+++ b/drivers/edac/edac_mc_sysfs.c
@@ -7,7 +7,7 @@
  *
  * Written Doug Thompson <norsk5@xmission.com> www.softwarebitmaker.com
  *
- * (c) 2012-2013 - Mauro Carvalho Chehab <mchehab@redhat.com>
+ * (c) 2012-2013 - Mauro Carvalho Chehab <m.chehab@samsung.com>
  *	The entire API were re-written, and ported to use struct device
  *
  */
diff --git a/drivers/edac/ghes_edac.c b/drivers/edac/ghes_edac.c
index bb53467..a414f8e 100644
--- a/drivers/edac/ghes_edac.c
+++ b/drivers/edac/ghes_edac.c
@@ -4,7 +4,7 @@
  * This file may be distributed under the terms of the GNU General Public
  * License version 2.
  *
- * Copyright (c) 2013 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2013 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * Red Hat Inc. http://www.redhat.com
  */
diff --git a/drivers/edac/i5400_edac.c b/drivers/edac/i5400_edac.c
index 0a05bbc..c62cec5 100644
--- a/drivers/edac/i5400_edac.c
+++ b/drivers/edac/i5400_edac.c
@@ -6,7 +6,7 @@
  *
  * Copyright (c) 2008 by:
  *	 Ben Woodard <woodard@redhat.com>
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * Red Hat Inc. http://www.redhat.com
  *
@@ -1467,7 +1467,7 @@ module_exit(i5400_exit);
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Ben Woodard <woodard@redhat.com>");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel I5400 memory controllers - "
 		   I5400_REVISION);
diff --git a/drivers/edac/i7300_edac.c b/drivers/edac/i7300_edac.c
index 9004c64..ee2965c 100644
--- a/drivers/edac/i7300_edac.c
+++ b/drivers/edac/i7300_edac.c
@@ -5,7 +5,7 @@
  * GNU General Public License version 2 only.
  *
  * Copyright (c) 2010 by:
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * Red Hat Inc. http://www.redhat.com
  *
@@ -1207,7 +1207,7 @@ module_init(i7300_init);
 module_exit(i7300_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel I7300 memory controllers - "
 		   I7300_REVISION);
diff --git a/drivers/edac/i7core_edac.c b/drivers/edac/i7core_edac.c
index 0ec3e95..68aec47 100644
--- a/drivers/edac/i7core_edac.c
+++ b/drivers/edac/i7core_edac.c
@@ -9,7 +9,7 @@
  * GNU General Public License version 2 only.
  *
  * Copyright (c) 2009-2010 by:
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * Red Hat Inc. http://www.redhat.com
  *
@@ -2456,7 +2456,7 @@ module_init(i7core_init);
 module_exit(i7core_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel i7 Core memory controllers - "
 		   I7CORE_REVISION);
diff --git a/drivers/edac/sb_edac.c b/drivers/edac/sb_edac.c
index e04462b..8bdaaab 100644
--- a/drivers/edac/sb_edac.c
+++ b/drivers/edac/sb_edac.c
@@ -7,7 +7,7 @@
  * GNU General Public License version 2 only.
  *
  * Copyright (c) 2011 by:
- *	 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *	 Mauro Carvalho Chehab <m.chehab@samsung.com>
  */
 
 #include <linux/module.h>
@@ -1837,7 +1837,7 @@ module_param(edac_op_state, int, 0444);
 MODULE_PARM_DESC(edac_op_state, "EDAC Error Reporting state: 0=Poll,1=NMI");
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("MC Driver for Intel Sandy Bridge memory controllers - "
 		   SBRIDGE_REVISION);
diff --git a/drivers/media/common/siano/smsdvb-debugfs.c b/drivers/media/common/siano/smsdvb-debugfs.c
index 0bb4430..70bcb43 100644
--- a/drivers/media/common/siano/smsdvb-debugfs.c
+++ b/drivers/media/common/siano/smsdvb-debugfs.c
@@ -1,6 +1,6 @@
 /***********************************************************************
  *
- * Copyright(c) 2013 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright(c) 2013 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software: you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/dvb-frontends/mb86a20s.c b/drivers/media/dvb-frontends/mb86a20s.c
index 856374b..ddd6641 100644
--- a/drivers/media/dvb-frontends/mb86a20s.c
+++ b/drivers/media/dvb-frontends/mb86a20s.c
@@ -1,7 +1,7 @@
 /*
  *   Fujitu mb86a20s ISDB-T/ISDB-Tsb Module driver
  *
- *   Copyright (C) 2010-2013 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2010-2013 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *   Copyright (C) 2009-2010 Douglas Landgraf <dougsland@redhat.com>
  *
  *   This program is free software; you can redistribute it and/or
@@ -2158,5 +2158,5 @@ static struct dvb_frontend_ops mb86a20s_ops = {
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Fujitsu mb86A20s hardware");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/mb86a20s.h b/drivers/media/dvb-frontends/mb86a20s.h
index 6627a39..fa92673 100644
--- a/drivers/media/dvb-frontends/mb86a20s.h
+++ b/drivers/media/dvb-frontends/mb86a20s.h
@@ -1,7 +1,7 @@
 /*
  *   Fujitsu mb86a20s driver
  *
- *   Copyright (C) 2010 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2010 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  *   This program is free software; you can redistribute it and/or
  *   modify it under the terms of the GNU General Public License as
diff --git a/drivers/media/dvb-frontends/s921.c b/drivers/media/dvb-frontends/s921.c
index a271ac3..ab52b9d 100644
--- a/drivers/media/dvb-frontends/s921.c
+++ b/drivers/media/dvb-frontends/s921.c
@@ -2,7 +2,7 @@
  *   Sharp VA3A5JZ921 One Seg Broadcast Module driver
  *   This device is labeled as just S. 921 at the top of the frontend can
  *
- *   Copyright (C) 2009-2010 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2009-2010 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *   Copyright (C) 2009-2010 Douglas Landgraf <dougsland@redhat.com>
  *
  *   Developed for Leadership SBTVD 1seg device sold in Brazil
@@ -539,6 +539,6 @@ static struct dvb_frontend_ops s921_ops = {
 };
 
 MODULE_DESCRIPTION("DVB Frontend module for Sharp S921 hardware");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_AUTHOR("Douglas Landgraf <dougsland@redhat.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/dvb-frontends/s921.h b/drivers/media/dvb-frontends/s921.h
index 8d5e2a6..cac955b 100644
--- a/drivers/media/dvb-frontends/s921.h
+++ b/drivers/media/dvb-frontends/s921.h
@@ -1,7 +1,7 @@
 /*
  *   Sharp s921 driver
  *
- *   Copyright (C) 2009 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2009 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *   Copyright (C) 2009 Douglas Landgraf <dougsland@redhat.com>
  *
  *   This program is free software; you can redistribute it and/or
diff --git a/drivers/media/i2c/mt9v011.c b/drivers/media/i2c/mt9v011.c
index f74698c..bd99cf5 100644
--- a/drivers/media/i2c/mt9v011.c
+++ b/drivers/media/i2c/mt9v011.c
@@ -1,7 +1,7 @@
 /*
  * mt9v011 -Micron 1/4-Inch VGA Digital Image Sensor
  *
- * Copyright (c) 2009 Mauro Carvalho Chehab (mchehab@redhat.com)
+ * Copyright (c) 2009 Mauro Carvalho Chehab (m.chehab@samsung.com)
  * This code is placed under the terms of the GNU General Public License v2
  */
 
@@ -16,7 +16,7 @@
 #include <media/mt9v011.h>
 
 MODULE_DESCRIPTION("Micron mt9v011 sensor driver");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_LICENSE("GPL");
 
 static int debug;
diff --git a/drivers/media/i2c/sr030pc30.c b/drivers/media/i2c/sr030pc30.c
index ae94326..f284c9f 100644
--- a/drivers/media/i2c/sr030pc30.c
+++ b/drivers/media/i2c/sr030pc30.c
@@ -8,7 +8,7 @@
  * and HeungJun Kim <riverful.kim@samsung.com>.
  *
  * Based on mt9v011 Micron Digital Image Sensor driver
- * Copyright (c) 2009 Mauro Carvalho Chehab (mchehab@redhat.com)
+ * Copyright (c) 2009 Mauro Carvalho Chehab (m.chehab@samsung.com)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/ir-nec-decoder.c b/drivers/media/rc/ir-nec-decoder.c
index 9a90094..5a293fc 100644
--- a/drivers/media/rc/ir-nec-decoder.c
+++ b/drivers/media/rc/ir-nec-decoder.c
@@ -1,6 +1,6 @@
 /* ir-nec-decoder.c - handle NEC IR Pulse/Space protocol
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -222,6 +222,6 @@ module_init(ir_nec_decode_init);
 module_exit(ir_nec_decode_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("NEC IR protocol decoder");
diff --git a/drivers/media/rc/ir-raw.c b/drivers/media/rc/ir-raw.c
index 5c42750..7684024 100644
--- a/drivers/media/rc/ir-raw.c
+++ b/drivers/media/rc/ir-raw.c
@@ -1,6 +1,6 @@
 /* ir-raw.c - handle IR pulse/space events
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/ir-rc5-decoder.c b/drivers/media/rc/ir-rc5-decoder.c
index 4e53a31..c57737d 100644
--- a/drivers/media/rc/ir-rc5-decoder.c
+++ b/drivers/media/rc/ir-rc5-decoder.c
@@ -1,6 +1,6 @@
 /* ir-rc5-decoder.c - handle RC5(x) IR Pulse/Space protocol
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -193,6 +193,6 @@ module_init(ir_rc5_decode_init);
 module_exit(ir_rc5_decode_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("RC5(x) IR protocol decoder");
diff --git a/drivers/media/rc/ir-rc5-sz-decoder.c b/drivers/media/rc/ir-rc5-sz-decoder.c
index 865fe84..3652e1e 100644
--- a/drivers/media/rc/ir-rc5-sz-decoder.c
+++ b/drivers/media/rc/ir-rc5-sz-decoder.c
@@ -1,6 +1,6 @@
 /* ir-rc5-sz-decoder.c - handle RC5 Streamzap IR Pulse/Space protocol
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  * Copyright (C) 2010 by Jarod Wilson <jarod@redhat.com>
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/media/rc/ir-sanyo-decoder.c b/drivers/media/rc/ir-sanyo-decoder.c
index 0a06205..19f8928 100644
--- a/drivers/media/rc/ir-sanyo-decoder.c
+++ b/drivers/media/rc/ir-sanyo-decoder.c
@@ -1,6 +1,6 @@
 /* ir-sanyo-decoder.c - handle SANYO IR Pulse/Space protocol
  *
- * Copyright (C) 2011 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2011 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -200,6 +200,6 @@ module_init(ir_sanyo_decode_init);
 module_exit(ir_sanyo_decode_exit);
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_AUTHOR("Red Hat Inc. (http://www.redhat.com)");
 MODULE_DESCRIPTION("SANYO IR protocol decoder");
diff --git a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
index b0e42df..dd312cf 100644
--- a/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
+++ b/drivers/media/rc/keymaps/rc-adstech-dvb-t-pci.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -87,4 +87,4 @@ module_init(init_rc_map_adstech_dvb_t_pci)
 module_exit(exit_rc_map_adstech_dvb_t_pci)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-apac-viewcomp.c b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
index 8c92ff9..a5e4253 100644
--- a/drivers/media/rc/keymaps/rc-apac-viewcomp.c
+++ b/drivers/media/rc/keymaps/rc-apac-viewcomp.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -78,4 +78,4 @@ module_init(init_rc_map_apac_viewcomp)
 module_exit(exit_rc_map_apac_viewcomp)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-asus-pc39.c b/drivers/media/rc/keymaps/rc-asus-pc39.c
index 2caf211..fbebb96 100644
--- a/drivers/media/rc/keymaps/rc-asus-pc39.c
+++ b/drivers/media/rc/keymaps/rc-asus-pc39.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -89,4 +89,4 @@ module_init(init_rc_map_asus_pc39)
 module_exit(exit_rc_map_asus_pc39)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-asus-ps3-100.c b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
index ba76609..9f41e8d 100644
--- a/drivers/media/rc/keymaps/rc-asus-ps3-100.c
+++ b/drivers/media/rc/keymaps/rc-asus-ps3-100.c
@@ -1,6 +1,6 @@
 /* asus-ps3-100.h - Keytable for asus_ps3_100 Remote Controller
  *
- * Copyright (c) 2012 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2012 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * Based on a previous patch from Remi Schwartz <remi.schwartz@gmail.com>
  *
@@ -88,4 +88,4 @@ module_init(init_rc_map_asus_ps3_100)
 module_exit(exit_rc_map_asus_ps3_100)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
index 2031224..0d1d0a6 100644
--- a/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
+++ b/drivers/media/rc/keymaps/rc-ati-tv-wonder-hd-600.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,4 +67,4 @@ module_init(init_rc_map_ati_tv_wonder_hd_600)
 module_exit(exit_rc_map_ati_tv_wonder_hd_600)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-a16d.c b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
index 894939a..37b6918 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-a16d.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-a16d.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -73,4 +73,4 @@ module_init(init_rc_map_avermedia_a16d)
 module_exit(exit_rc_map_avermedia_a16d)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
index d2aaf5b..9bcddc3 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-cardbus.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -95,4 +95,4 @@ module_init(init_rc_map_avermedia_cardbus)
 module_exit(exit_rc_map_avermedia_cardbus)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
index dc2baf0..60c8804 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-dvbt.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_avermedia_dvbt)
 module_exit(exit_rc_map_avermedia_dvbt)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m135a.c b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
index 04269d3..57945a2 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m135a.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m135a.c
@@ -1,6 +1,6 @@
 /* avermedia-m135a.c - Keytable for Avermedia M135A Remote Controllers
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  * Copyright (c) 2010 by Herton Ronaldo Krzesinski <herton@mandriva.com.br>
  *
  * This program is free software; you can redistribute it and/or modify
@@ -145,4 +145,4 @@ module_init(init_rc_map_avermedia_m135a)
 module_exit(exit_rc_map_avermedia_m135a)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
index e83b1a1..aa48dd6 100644
--- a/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
+++ b/drivers/media/rc/keymaps/rc-avermedia-m733a-rm-k6.c
@@ -93,4 +93,4 @@ module_init(init_rc_map_avermedia_m733a_rm_k6)
 module_exit(exit_rc_map_avermedia_m733a_rm_k6)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-avermedia.c b/drivers/media/rc/keymaps/rc-avermedia.c
index c6063df..3dc2de3 100644
--- a/drivers/media/rc/keymaps/rc-avermedia.c
+++ b/drivers/media/rc/keymaps/rc-avermedia.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -84,4 +84,4 @@ module_init(init_rc_map_avermedia)
 module_exit(exit_rc_map_avermedia)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-avertv-303.c b/drivers/media/rc/keymaps/rc-avertv-303.c
index 14f7845..a87f2b8 100644
--- a/drivers/media/rc/keymaps/rc-avertv-303.c
+++ b/drivers/media/rc/keymaps/rc-avertv-303.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -83,4 +83,4 @@ module_init(init_rc_map_avertv_303)
 module_exit(exit_rc_map_avertv_303)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-behold-columbus.c b/drivers/media/rc/keymaps/rc-behold-columbus.c
index 086b4b1..2abe92f 100644
--- a/drivers/media/rc/keymaps/rc-behold-columbus.c
+++ b/drivers/media/rc/keymaps/rc-behold-columbus.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -106,4 +106,4 @@ module_init(init_rc_map_behold_columbus)
 module_exit(exit_rc_map_behold_columbus)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-behold.c b/drivers/media/rc/keymaps/rc-behold.c
index 0877e34..5952e3d 100644
--- a/drivers/media/rc/keymaps/rc-behold.c
+++ b/drivers/media/rc/keymaps/rc-behold.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -139,4 +139,4 @@ module_init(init_rc_map_behold)
 module_exit(exit_rc_map_behold)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-budget-ci-old.c b/drivers/media/rc/keymaps/rc-budget-ci-old.c
index 8311e09..45f220e 100644
--- a/drivers/media/rc/keymaps/rc-budget-ci-old.c
+++ b/drivers/media/rc/keymaps/rc-budget-ci-old.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -91,4 +91,4 @@ module_init(init_rc_map_budget_ci_old)
 module_exit(exit_rc_map_budget_ci_old)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-cinergy-1400.c b/drivers/media/rc/keymaps/rc-cinergy-1400.c
index 0c87fba..cfed53b 100644
--- a/drivers/media/rc/keymaps/rc-cinergy-1400.c
+++ b/drivers/media/rc/keymaps/rc-cinergy-1400.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -82,4 +82,4 @@ module_init(init_rc_map_cinergy_1400)
 module_exit(exit_rc_map_cinergy_1400)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-cinergy.c b/drivers/media/rc/keymaps/rc-cinergy.c
index 309e9e3..75791a4 100644
--- a/drivers/media/rc/keymaps/rc-cinergy.c
+++ b/drivers/media/rc/keymaps/rc-cinergy.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_cinergy)
 module_exit(exit_rc_map_cinergy)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-dib0700-nec.c b/drivers/media/rc/keymaps/rc-dib0700-nec.c
index 4d13a7f..3c57405 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-nec.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-nec.c
@@ -1,6 +1,6 @@
 /* rc-dvb0700-big.c - Keytable for devices in dvb0700
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * TODO: This table is a real mess, as it merges RC codes from several
  * devices into a big table. It also has both RC-5 and NEC codes inside.
@@ -122,4 +122,4 @@ module_init(init_rc_map)
 module_exit(exit_rc_map)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-dib0700-rc5.c b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
index ba81d96..f279324 100644
--- a/drivers/media/rc/keymaps/rc-dib0700-rc5.c
+++ b/drivers/media/rc/keymaps/rc-dib0700-rc5.c
@@ -1,6 +1,6 @@
 /* rc-dvb0700-big.c - Keytable for devices in dvb0700
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * TODO: This table is a real mess, as it merges RC codes from several
  * devices into a big table. It also has both RC-5 and NEC codes inside.
@@ -233,4 +233,4 @@ module_init(init_rc_map)
 module_exit(exit_rc_map)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-dm1105-nec.c b/drivers/media/rc/keymaps/rc-dm1105-nec.c
index 67fc9fb..d377efa 100644
--- a/drivers/media/rc/keymaps/rc-dm1105-nec.c
+++ b/drivers/media/rc/keymaps/rc-dm1105-nec.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -74,4 +74,4 @@ module_init(init_rc_map_dm1105_nec)
 module_exit(exit_rc_map_dm1105_nec)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
index 91ea91d..e51be04 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvb-t.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_dntv_live_dvb_t)
 module_exit(exit_rc_map_dntv_live_dvb_t)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
index fd680d4..222acb0 100644
--- a/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
+++ b/drivers/media/rc/keymaps/rc-dntv-live-dvbt-pro.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -95,4 +95,4 @@ module_init(init_rc_map_dntv_live_dvbt_pro)
 module_exit(exit_rc_map_dntv_live_dvbt_pro)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-em-terratec.c b/drivers/media/rc/keymaps/rc-em-terratec.c
index d1fcd64..3742246 100644
--- a/drivers/media/rc/keymaps/rc-em-terratec.c
+++ b/drivers/media/rc/keymaps/rc-em-terratec.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,4 +67,4 @@ module_init(init_rc_map_em_terratec)
 module_exit(exit_rc_map_em_terratec)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
index 2fe45e4..2ccb379 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv-fm53.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -79,4 +79,4 @@ module_init(init_rc_map_encore_enltv_fm53)
 module_exit(exit_rc_map_encore_enltv_fm53)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv.c b/drivers/media/rc/keymaps/rc-encore-enltv.c
index 223de75..b43e4bd 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -110,4 +110,4 @@ module_init(init_rc_map_encore_enltv)
 module_exit(exit_rc_map_encore_enltv)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-encore-enltv2.c b/drivers/media/rc/keymaps/rc-encore-enltv2.c
index 669cbff..b0c91d1 100644
--- a/drivers/media/rc/keymaps/rc-encore-enltv2.c
+++ b/drivers/media/rc/keymaps/rc-encore-enltv2.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -88,4 +88,4 @@ module_init(init_rc_map_encore_enltv2)
 module_exit(exit_rc_map_encore_enltv2)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-evga-indtube.c b/drivers/media/rc/keymaps/rc-evga-indtube.c
index 2c647fc..ed51d0f 100644
--- a/drivers/media/rc/keymaps/rc-evga-indtube.c
+++ b/drivers/media/rc/keymaps/rc-evga-indtube.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -59,4 +59,4 @@ module_init(init_rc_map_evga_indtube)
 module_exit(exit_rc_map_evga_indtube)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-eztv.c b/drivers/media/rc/keymaps/rc-eztv.c
index 7692144..0bf050d 100644
--- a/drivers/media/rc/keymaps/rc-eztv.c
+++ b/drivers/media/rc/keymaps/rc-eztv.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -94,4 +94,4 @@ module_init(init_rc_map_eztv)
 module_exit(exit_rc_map_eztv)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-flydvb.c b/drivers/media/rc/keymaps/rc-flydvb.c
index 3a6bba3..4104268 100644
--- a/drivers/media/rc/keymaps/rc-flydvb.c
+++ b/drivers/media/rc/keymaps/rc-flydvb.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -75,4 +75,4 @@ module_init(init_rc_map_flydvb)
 module_exit(exit_rc_map_flydvb)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-flyvideo.c b/drivers/media/rc/keymaps/rc-flyvideo.c
index bf9da58..cbb35e1 100644
--- a/drivers/media/rc/keymaps/rc-flyvideo.c
+++ b/drivers/media/rc/keymaps/rc-flyvideo.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -68,4 +68,4 @@ module_init(init_rc_map_flyvideo)
 module_exit(exit_rc_map_flyvideo)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
index 2f0970f..1a1650d 100644
--- a/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
+++ b/drivers/media/rc/keymaps/rc-fusionhdtv-mce.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -96,4 +96,4 @@ module_init(init_rc_map_fusionhdtv_mce)
 module_exit(exit_rc_map_fusionhdtv_mce)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
index 0e98ec4..2aac08e 100644
--- a/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
+++ b/drivers/media/rc/keymaps/rc-gadmei-rm008z.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -79,4 +79,4 @@ module_init(init_rc_map_gadmei_rm008z)
 module_exit(exit_rc_map_gadmei_rm008z)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
index a2e2faa..ac7e59a 100644
--- a/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
+++ b/drivers/media/rc/keymaps/rc-genius-tvgo-a11mce.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -82,4 +82,4 @@ module_init(init_rc_map_genius_tvgo_a11mce)
 module_exit(exit_rc_map_genius_tvgo_a11mce)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-gotview7135.c b/drivers/media/rc/keymaps/rc-gotview7135.c
index 864614e..0786cd4 100644
--- a/drivers/media/rc/keymaps/rc-gotview7135.c
+++ b/drivers/media/rc/keymaps/rc-gotview7135.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -77,4 +77,4 @@ module_init(init_rc_map_gotview7135)
 module_exit(exit_rc_map_gotview7135)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-hauppauge.c b/drivers/media/rc/keymaps/rc-hauppauge.c
index 929bbbc..8c89b36 100644
--- a/drivers/media/rc/keymaps/rc-hauppauge.c
+++ b/drivers/media/rc/keymaps/rc-hauppauge.c
@@ -8,7 +8,7 @@
  *	- Hauppauge Black;
  *	- DSR-0112 remote bundled with Haupauge MiniStick.
  *
- * Copyright (c) 2010-2011 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010-2011 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -290,4 +290,4 @@ module_init(init_rc_map_rc5_hauppauge_new)
 module_exit(exit_rc_map_rc5_hauppauge_new)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
index 34540df..d54df31 100644
--- a/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
+++ b/drivers/media/rc/keymaps/rc-iodata-bctv7e.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -86,4 +86,4 @@ module_init(init_rc_map_iodata_bctv7e)
 module_exit(exit_rc_map_iodata_bctv7e)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-kaiomy.c b/drivers/media/rc/keymaps/rc-kaiomy.c
index 4264a78..0538b0d 100644
--- a/drivers/media/rc/keymaps/rc-kaiomy.c
+++ b/drivers/media/rc/keymaps/rc-kaiomy.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -85,4 +85,4 @@ module_init(init_rc_map_kaiomy)
 module_exit(exit_rc_map_kaiomy)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-kworld-315u.c b/drivers/media/rc/keymaps/rc-kworld-315u.c
index e48cd26..0b5bec4 100644
--- a/drivers/media/rc/keymaps/rc-kworld-315u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-315u.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -81,4 +81,4 @@ module_init(init_rc_map_kworld_315u)
 module_exit(exit_rc_map_kworld_315u)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-kworld-pc150u.c b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
index 233bb5e..08d5769 100644
--- a/drivers/media/rc/keymaps/rc-kworld-pc150u.c
+++ b/drivers/media/rc/keymaps/rc-kworld-pc150u.c
@@ -4,7 +4,7 @@
  *
  * Copyright (c) 2010 by Kyle Strickland
  *   (based on kworld-plus-tv-analog.c by
- *    Mauro Carvalho Chehab <mchehab@redhat.com>)
+ *    Mauro Carvalho Chehab <m.chehab@samsung.com>)
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
index 32998d6..47adfca 100644
--- a/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
+++ b/drivers/media/rc/keymaps/rc-kworld-plus-tv-analog.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -97,4 +97,4 @@ module_init(init_rc_map_kworld_plus_tv_analog)
 module_exit(exit_rc_map_kworld_plus_tv_analog)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-manli.c b/drivers/media/rc/keymaps/rc-manli.c
index e7038bb..6d13d99 100644
--- a/drivers/media/rc/keymaps/rc-manli.c
+++ b/drivers/media/rc/keymaps/rc-manli.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -132,4 +132,4 @@ module_init(init_rc_map_manli)
 module_exit(exit_rc_map_manli)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
index c393d8a..979da60 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere-plus.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -121,4 +121,4 @@ module_init(init_rc_map_msi_tvanywhere_plus)
 module_exit(exit_rc_map_msi_tvanywhere_plus)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
index a7003d3..34a1f12 100644
--- a/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
+++ b/drivers/media/rc/keymaps/rc-msi-tvanywhere.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,4 +67,4 @@ module_init(init_rc_map_msi_tvanywhere)
 module_exit(exit_rc_map_msi_tvanywhere)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-nebula.c b/drivers/media/rc/keymaps/rc-nebula.c
index 3f0ddd7..bd97b84 100644
--- a/drivers/media/rc/keymaps/rc-nebula.c
+++ b/drivers/media/rc/keymaps/rc-nebula.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -94,4 +94,4 @@ module_init(init_rc_map_nebula)
 module_exit(exit_rc_map_nebula)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
index 8d4dae2..2261b98 100644
--- a/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-nec-terratec-cinergy-xs.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -14,7 +14,7 @@
 #include <linux/module.h>
 
 /* Terratec Cinergy Hybrid T USB XS FM
-   Mauro Carvalho Chehab <mchehab@redhat.com>
+   Mauro Carvalho Chehab <m.chehab@samsung.com>
  */
 
 static struct rc_map_table nec_terratec_cinergy_xs[] = {
@@ -155,4 +155,4 @@ module_init(init_rc_map_nec_terratec_cinergy_xs)
 module_exit(exit_rc_map_nec_terratec_cinergy_xs)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-norwood.c b/drivers/media/rc/keymaps/rc-norwood.c
index 9e65f07..5f1d50f 100644
--- a/drivers/media/rc/keymaps/rc-norwood.c
+++ b/drivers/media/rc/keymaps/rc-norwood.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -83,4 +83,4 @@ module_init(init_rc_map_norwood)
 module_exit(exit_rc_map_norwood)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-npgtech.c b/drivers/media/rc/keymaps/rc-npgtech.c
index 65d0cfc..b89c703 100644
--- a/drivers/media/rc/keymaps/rc-npgtech.c
+++ b/drivers/media/rc/keymaps/rc-npgtech.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -78,4 +78,4 @@ module_init(init_rc_map_npgtech)
 module_exit(exit_rc_map_npgtech)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pctv-sedna.c b/drivers/media/rc/keymaps/rc-pctv-sedna.c
index bf2cbdf..59b80c7 100644
--- a/drivers/media/rc/keymaps/rc-pctv-sedna.c
+++ b/drivers/media/rc/keymaps/rc-pctv-sedna.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -78,4 +78,4 @@ module_init(init_rc_map_pctv_sedna)
 module_exit(exit_rc_map_pctv_sedna)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-color.c b/drivers/media/rc/keymaps/rc-pinnacle-color.c
index b46cd8f..8c92d68 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-color.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-color.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -92,4 +92,4 @@ module_init(init_rc_map_pinnacle_color)
 module_exit(exit_rc_map_pinnacle_color)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-grey.c b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
index d525df9..a45af6d 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-grey.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-grey.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -87,4 +87,4 @@ module_init(init_rc_map_pinnacle_grey)
 module_exit(exit_rc_map_pinnacle_grey)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
index a4603d0..653848a 100644
--- a/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
+++ b/drivers/media/rc/keymaps/rc-pinnacle-pctv-hd.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -68,4 +68,4 @@ module_init(init_rc_map_pinnacle_pctv_hd)
 module_exit(exit_rc_map_pinnacle_pctv_hd)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-002t.c b/drivers/media/rc/keymaps/rc-pixelview-002t.c
index 33eb643..08c8c8d 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-002t.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-002t.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -75,4 +75,4 @@ module_init(init_rc_map_pixelview)
 module_exit(exit_rc_map_pixelview)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-mk12.c b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
index 21f4dd2..b0c7ea9 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-mk12.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-mk12.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -81,4 +81,4 @@ module_init(init_rc_map_pixelview)
 module_exit(exit_rc_map_pixelview)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview-new.c b/drivers/media/rc/keymaps/rc-pixelview-new.c
index f944ad2..d9c8c4b 100644
--- a/drivers/media/rc/keymaps/rc-pixelview-new.c
+++ b/drivers/media/rc/keymaps/rc-pixelview-new.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -81,4 +81,4 @@ module_init(init_rc_map_pixelview_new)
 module_exit(exit_rc_map_pixelview_new)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pixelview.c b/drivers/media/rc/keymaps/rc-pixelview.c
index a6020ee..9ff2cb6 100644
--- a/drivers/media/rc/keymaps/rc-pixelview.c
+++ b/drivers/media/rc/keymaps/rc-pixelview.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -80,4 +80,4 @@ module_init(init_rc_map_pixelview)
 module_exit(exit_rc_map_pixelview)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
index e74c571..62fff5f 100644
--- a/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
+++ b/drivers/media/rc/keymaps/rc-powercolor-real-angel.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -79,4 +79,4 @@ module_init(init_rc_map_powercolor_real_angel)
 module_exit(exit_rc_map_powercolor_real_angel)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-proteus-2309.c b/drivers/media/rc/keymaps/rc-proteus-2309.c
index adee803..2e44715 100644
--- a/drivers/media/rc/keymaps/rc-proteus-2309.c
+++ b/drivers/media/rc/keymaps/rc-proteus-2309.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -67,4 +67,4 @@ module_init(init_rc_map_proteus_2309)
 module_exit(exit_rc_map_proteus_2309)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-purpletv.c b/drivers/media/rc/keymaps/rc-purpletv.c
index 722597a..ab5eaa1 100644
--- a/drivers/media/rc/keymaps/rc-purpletv.c
+++ b/drivers/media/rc/keymaps/rc-purpletv.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -79,4 +79,4 @@ module_init(init_rc_map_purpletv)
 module_exit(exit_rc_map_purpletv)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-pv951.c b/drivers/media/rc/keymaps/rc-pv951.c
index 0105d63..41a6b6e 100644
--- a/drivers/media/rc/keymaps/rc-pv951.c
+++ b/drivers/media/rc/keymaps/rc-pv951.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_pv951)
 module_exit(exit_rc_map_pv951)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
index 073694d..5c334e2 100644
--- a/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
+++ b/drivers/media/rc/keymaps/rc-real-audio-220-32-keys.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -76,4 +76,4 @@ module_init(init_rc_map_real_audio_220_32_keys)
 module_exit(exit_rc_map_real_audio_220_32_keys)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-tbs-nec.c b/drivers/media/rc/keymaps/rc-tbs-nec.c
index 5039be7..f5cd33c 100644
--- a/drivers/media/rc/keymaps/rc-tbs-nec.c
+++ b/drivers/media/rc/keymaps/rc-tbs-nec.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -73,4 +73,4 @@ module_init(init_rc_map_tbs_nec)
 module_exit(exit_rc_map_tbs_nec)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
index 53629fb..8a06f5b 100644
--- a/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
+++ b/drivers/media/rc/keymaps/rc-terratec-cinergy-xs.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -90,4 +90,4 @@ module_init(init_rc_map_terratec_cinergy_xs)
 module_exit(exit_rc_map_terratec_cinergy_xs)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-tevii-nec.c b/drivers/media/rc/keymaps/rc-tevii-nec.c
index f2c3b75..d323db6 100644
--- a/drivers/media/rc/keymaps/rc-tevii-nec.c
+++ b/drivers/media/rc/keymaps/rc-tevii-nec.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -86,4 +86,4 @@ module_init(init_rc_map_tevii_nec)
 module_exit(exit_rc_map_tevii_nec)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-tt-1500.c b/drivers/media/rc/keymaps/rc-tt-1500.c
index 80217ff..43d12a9 100644
--- a/drivers/media/rc/keymaps/rc-tt-1500.c
+++ b/drivers/media/rc/keymaps/rc-tt-1500.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -80,4 +80,4 @@ module_init(init_rc_map_tt_1500)
 module_exit(exit_rc_map_tt_1500)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-videomate-s350.c b/drivers/media/rc/keymaps/rc-videomate-s350.c
index 8bfc3e8..bdddd11 100644
--- a/drivers/media/rc/keymaps/rc-videomate-s350.c
+++ b/drivers/media/rc/keymaps/rc-videomate-s350.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -83,4 +83,4 @@ module_init(init_rc_map_videomate_s350)
 module_exit(exit_rc_map_videomate_s350)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
index 390ce94..423859b 100644
--- a/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
+++ b/drivers/media/rc/keymaps/rc-videomate-tv-pvr.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -85,4 +85,4 @@ module_init(init_rc_map_videomate_tv_pvr)
 module_exit(exit_rc_map_videomate_tv_pvr)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
index 2852bf7..6c332e5 100644
--- a/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
+++ b/drivers/media/rc/keymaps/rc-winfast-usbii-deluxe.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -80,4 +80,4 @@ module_init(init_rc_map_winfast_usbii_deluxe)
 module_exit(exit_rc_map_winfast_usbii_deluxe)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/keymaps/rc-winfast.c b/drivers/media/rc/keymaps/rc-winfast.c
index 2df1cba..f0b238d 100644
--- a/drivers/media/rc/keymaps/rc-winfast.c
+++ b/drivers/media/rc/keymaps/rc-winfast.c
@@ -2,7 +2,7 @@
  *
  * keymap imported from ir-keymaps.c
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
@@ -100,4 +100,4 @@ module_init(init_rc_map_winfast)
 module_exit(exit_rc_map_winfast)
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
diff --git a/drivers/media/rc/rc-core-priv.h b/drivers/media/rc/rc-core-priv.h
index 70a180b..2931ebb 100644
--- a/drivers/media/rc/rc-core-priv.h
+++ b/drivers/media/rc/rc-core-priv.h
@@ -1,7 +1,7 @@
 /*
  * Remote Controller core raw events header
  *
- * Copyright (C) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/media/rc/rc-main.c b/drivers/media/rc/rc-main.c
index 1cf382a..0990ffe 100644
--- a/drivers/media/rc/rc-main.c
+++ b/drivers/media/rc/rc-main.c
@@ -1,6 +1,6 @@
 /* rc-main.c - Remote Controller core module
  *
- * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
@@ -1202,5 +1202,5 @@ int rc_core_debug;    /* ir_debug level (0,1,2) */
 EXPORT_SYMBOL_GPL(rc_core_debug);
 module_param_named(debug, rc_core_debug, int, 0644);
 
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/mt2063.c b/drivers/media/tuners/mt2063.c
index 2e1a02e..9528cef 100644
--- a/drivers/media/tuners/mt2063.c
+++ b/drivers/media/tuners/mt2063.c
@@ -1,7 +1,7 @@
 /*
  * Driver for mt2063 Micronas tuner
  *
- * Copyright (c) 2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2011 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This driver came from a driver originally written by:
  *		Henry Wang <Henry.wang@AzureWave.com>
@@ -2298,6 +2298,6 @@ static int tuner_MT2063_ClearPowerMaskBits(struct dvb_frontend *fe)
 }
 #endif
 
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_DESCRIPTION("MT2063 Silicon tuner");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/tuners/r820t.c b/drivers/media/tuners/r820t.c
index 1c23666..a0d248a 100644
--- a/drivers/media/tuners/r820t.c
+++ b/drivers/media/tuners/r820t.c
@@ -1,7 +1,7 @@
 /*
  * Rafael Micro R820T driver
  *
- * Copyright (C) 2013 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2013 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This driver was written from scratch, based on an existing driver
  * that it is part of rtl-sdr git tree, released under GPLv2:
@@ -2347,5 +2347,5 @@ err_no_gate:
 EXPORT_SYMBOL_GPL(r820t_attach);
 
 MODULE_DESCRIPTION("Rafael Micro r820t silicon tuner driver");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/cx231xx/cx231xx-input.c b/drivers/media/usb/cx231xx/cx231xx-input.c
index 0f7b424..7a70a1d 100644
--- a/drivers/media/usb/cx231xx/cx231xx-input.c
+++ b/drivers/media/usb/cx231xx/cx231xx-input.c
@@ -1,7 +1,7 @@
 /*
  *   cx231xx IR glue driver
  *
- *   Copyright (C) 2010 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *   Copyright (C) 2010 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  *   Polaris (cx231xx) has its support for IR's with a design close to MCE.
  *   however, a few designs are using an external I2C chip for IR, instead
diff --git a/drivers/media/usb/dvb-usb-v2/az6007.c b/drivers/media/usb/dvb-usb-v2/az6007.c
index 44c64ef3..8f1e08e 100644
--- a/drivers/media/usb/dvb-usb-v2/az6007.c
+++ b/drivers/media/usb/dvb-usb-v2/az6007.c
@@ -7,7 +7,7 @@
  *	http://linux.terratec.de/files/TERRATEC_H7/20110323_TERRATEC_H7_Linux.tar.gz
  * The original driver's license is GPL, as declared with MODULE_LICENSE()
  *
- * Copyright (c) 2010-2012 Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010-2012 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *	Driver modified by in order to work with upstream drxk driver, and
  *	tons of bugs got fixed, and converted to use dvb-usb-v2.
  *
@@ -916,7 +916,7 @@ static struct usb_driver az6007_usb_driver = {
 module_usb_driver(az6007_usb_driver);
 
 MODULE_AUTHOR("Henry Wang <Henry.wang@AzureWave.com>");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_DESCRIPTION("Driver for AzureWave 6007 DVB-C/T USB2.0 and clones");
 MODULE_VERSION("2.0");
 MODULE_LICENSE("GPL");
diff --git a/drivers/media/usb/em28xx/em28xx-audio.c b/drivers/media/usb/em28xx/em28xx-audio.c
index 2fdb66e..68def1c 100644
--- a/drivers/media/usb/em28xx/em28xx-audio.c
+++ b/drivers/media/usb/em28xx/em28xx-audio.c
@@ -3,7 +3,7 @@
  *
  *  Copyright (C) 2006 Markus Rechberger <mrechberger@gmail.com>
  *
- *  Copyright (C) 2007-2011 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *  Copyright (C) 2007-2011 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *	- Port to work with the in-kernel driver
  *	- Cleanups, fixes, alsa-controls, etc.
  *
@@ -744,7 +744,7 @@ static void __exit em28xx_alsa_unregister(void)
 
 MODULE_LICENSE("GPL");
 MODULE_AUTHOR("Markus Rechberger <mrechberger@gmail.com>");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_DESCRIPTION("Em28xx Audio driver");
 
 module_init(em28xx_alsa_register);
diff --git a/drivers/media/usb/em28xx/em28xx-input.c b/drivers/media/usb/em28xx/em28xx-input.c
index ea181e4..23df70c 100644
--- a/drivers/media/usb/em28xx/em28xx-input.c
+++ b/drivers/media/usb/em28xx/em28xx-input.c
@@ -721,7 +721,7 @@ static void __exit em28xx_rc_unregister(void)
 }
 
 MODULE_LICENSE("GPL");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_DESCRIPTION("Em28xx Input driver");
 
 module_init(em28xx_rc_register);
diff --git a/drivers/media/usb/tm6000/tm6000-alsa.c b/drivers/media/usb/tm6000/tm6000-alsa.c
index 813c1ec..6ea45d8 100644
--- a/drivers/media/usb/tm6000/tm6000-alsa.c
+++ b/drivers/media/usb/tm6000/tm6000-alsa.c
@@ -1,7 +1,7 @@
 /*
  *
  *  Support for audio capture for tm5600/6000/6010
- *    (c) 2007-2008 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *    (c) 2007-2008 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  *  Based on cx88-alsa.c
  *
@@ -56,7 +56,7 @@ MODULE_PARM_DESC(index, "Index value for tm6000x capture interface(s).");
  ****************************************************************************/
 
 MODULE_DESCRIPTION("ALSA driver module for tm5600/tm6000/tm6010 based TV cards");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_LICENSE("GPL");
 MODULE_SUPPORTED_DEVICE("{{Trident,tm5600},"
 			"{{Trident,tm6000},"
diff --git a/drivers/media/usb/tm6000/tm6000-dvb.c b/drivers/media/usb/tm6000/tm6000-dvb.c
index 9fc1e94..42e5397 100644
--- a/drivers/media/usb/tm6000/tm6000-dvb.c
+++ b/drivers/media/usb/tm6000/tm6000-dvb.c
@@ -32,7 +32,7 @@
 #include "xc5000.h"
 
 MODULE_DESCRIPTION("DVB driver extension module for tm5600/6000/6010 based TV cards");
-MODULE_AUTHOR("Mauro Carvalho Chehab <mchehab@redhat.com>");
+MODULE_AUTHOR("Mauro Carvalho Chehab <m.chehab@samsung.com>");
 MODULE_LICENSE("GPL");
 
 MODULE_SUPPORTED_DEVICE("{{Trident, tm5600},"
diff --git a/drivers/media/usb/tm6000/tm6000-stds.c b/drivers/media/usb/tm6000/tm6000-stds.c
index 5e28d6a..5e51188 100644
--- a/drivers/media/usb/tm6000/tm6000-stds.c
+++ b/drivers/media/usb/tm6000/tm6000-stds.c
@@ -1,7 +1,7 @@
 /*
  *  tm6000-stds.c - driver for TM5600/TM6000/TM6010 USB video capture devices
  *
- *  Copyright (C) 2007 Mauro Carvalho Chehab <mchehab@redhat.com>
+ *  Copyright (C) 2007 Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  *  This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/drivers/staging/usbip/userspace/autogen.sh b/drivers/staging/usbip/userspace/autogen.sh
old mode 100755
new mode 100644
diff --git a/drivers/staging/usbip/userspace/cleanup.sh b/drivers/staging/usbip/userspace/cleanup.sh
old mode 100755
new mode 100644
diff --git a/include/media/rc-core.h b/include/media/rc-core.h
index 06a75de..6a6e293 100644
--- a/include/media/rc-core.h
+++ b/include/media/rc-core.h
@@ -1,7 +1,7 @@
 /*
  * Remote Controller core header
  *
- * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (C) 2009-2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  *  it under the terms of the GNU General Public License as published by
diff --git a/include/media/rc-map.h b/include/media/rc-map.h
index 6628f5d..23b13bc 100644
--- a/include/media/rc-map.h
+++ b/include/media/rc-map.h
@@ -1,7 +1,7 @@
 /*
  * rc-map.h - define RC map names used by RC drivers
  *
- * Copyright (c) 2010 by Mauro Carvalho Chehab <mchehab@redhat.com>
+ * Copyright (c) 2010 by Mauro Carvalho Chehab <m.chehab@samsung.com>
  *
  * This program is free software; you can redistribute it and/or modify
  * it under the terms of the GNU General Public License as published by
diff --git a/lib/build_OID_registry b/lib/build_OID_registry
old mode 100755
new mode 100644
diff --git a/scripts/Lindent b/scripts/Lindent
old mode 100755
new mode 100644
diff --git a/scripts/bloat-o-meter b/scripts/bloat-o-meter
old mode 100755
new mode 100644
diff --git a/scripts/checkincludes.pl b/scripts/checkincludes.pl
old mode 100755
new mode 100644
diff --git a/scripts/checkkconfigsymbols.sh b/scripts/checkkconfigsymbols.sh
old mode 100755
new mode 100644
diff --git a/scripts/checkpatch.pl b/scripts/checkpatch.pl
old mode 100755
new mode 100644
diff --git a/scripts/checkstack.pl b/scripts/checkstack.pl
old mode 100755
new mode 100644
diff --git a/scripts/checksyscalls.sh b/scripts/checksyscalls.sh
old mode 100755
new mode 100644
diff --git a/scripts/checkversion.pl b/scripts/checkversion.pl
old mode 100755
new mode 100644
diff --git a/scripts/cleanfile b/scripts/cleanfile
old mode 100755
new mode 100644
diff --git a/scripts/cleanpatch b/scripts/cleanpatch
old mode 100755
new mode 100644
diff --git a/scripts/coccicheck b/scripts/coccicheck
old mode 100755
new mode 100644
diff --git a/scripts/config b/scripts/config
old mode 100755
new mode 100644
diff --git a/scripts/decodecode b/scripts/decodecode
old mode 100755
new mode 100644
diff --git a/scripts/depmod.sh b/scripts/depmod.sh
old mode 100755
new mode 100644
diff --git a/scripts/diffconfig b/scripts/diffconfig
old mode 100755
new mode 100644
diff --git a/scripts/extract-ikconfig b/scripts/extract-ikconfig
old mode 100755
new mode 100644
diff --git a/scripts/extract-vmlinux b/scripts/extract-vmlinux
old mode 100755
new mode 100644
diff --git a/scripts/get_maintainer.pl b/scripts/get_maintainer.pl
old mode 100755
new mode 100644
diff --git a/scripts/gfp-translate b/scripts/gfp-translate
old mode 100755
new mode 100644
diff --git a/scripts/headerdep.pl b/scripts/headerdep.pl
old mode 100755
new mode 100644
diff --git a/scripts/headers.sh b/scripts/headers.sh
old mode 100755
new mode 100644
diff --git a/scripts/kconfig/check.sh b/scripts/kconfig/check.sh
old mode 100755
new mode 100644
diff --git a/scripts/kconfig/merge_config.sh b/scripts/kconfig/merge_config.sh
old mode 100755
new mode 100644
diff --git a/scripts/kernel-doc b/scripts/kernel-doc
old mode 100755
new mode 100644
diff --git a/scripts/makelst b/scripts/makelst
old mode 100755
new mode 100644
diff --git a/scripts/mkcompile_h b/scripts/mkcompile_h
old mode 100755
new mode 100644
diff --git a/scripts/mkuboot.sh b/scripts/mkuboot.sh
old mode 100755
new mode 100644
diff --git a/scripts/namespace.pl b/scripts/namespace.pl
old mode 100755
new mode 100644
diff --git a/scripts/package/mkspec b/scripts/package/mkspec
old mode 100755
new mode 100644
diff --git a/scripts/patch-kernel b/scripts/patch-kernel
old mode 100755
new mode 100644
diff --git a/scripts/recordmcount.pl b/scripts/recordmcount.pl
old mode 100755
new mode 100644
diff --git a/scripts/setlocalversion b/scripts/setlocalversion
old mode 100755
new mode 100644
diff --git a/scripts/show_delta b/scripts/show_delta
old mode 100755
new mode 100644
diff --git a/scripts/sign-file b/scripts/sign-file
old mode 100755
new mode 100644
diff --git a/scripts/tags.sh b/scripts/tags.sh
old mode 100755
new mode 100644
diff --git a/scripts/ver_linux b/scripts/ver_linux
old mode 100755
new mode 100644
diff --git a/tools/hv/hv_get_dhcp_info.sh b/tools/hv/hv_get_dhcp_info.sh
old mode 100755
new mode 100644
diff --git a/tools/hv/hv_get_dns_info.sh b/tools/hv/hv_get_dns_info.sh
old mode 100755
new mode 100644
diff --git a/tools/hv/hv_set_ifconfig.sh b/tools/hv/hv_set_ifconfig.sh
old mode 100755
new mode 100644
diff --git a/tools/nfsd/inject_fault.sh b/tools/nfsd/inject_fault.sh
old mode 100755
new mode 100644
diff --git a/tools/perf/python/twatch.py b/tools/perf/python/twatch.py
old mode 100755
new mode 100644
diff --git a/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py b/tools/perf/scripts/python/Perf-Trace-Util/lib/Perf/Trace/EventClass.py
old mode 100755
new mode 100644
diff --git a/tools/perf/scripts/python/bin/net_dropmonitor-record b/tools/perf/scripts/python/bin/net_dropmonitor-record
old mode 100755
new mode 100644
diff --git a/tools/perf/scripts/python/bin/net_dropmonitor-report b/tools/perf/scripts/python/bin/net_dropmonitor-report
old mode 100755
new mode 100644
diff --git a/tools/perf/scripts/python/net_dropmonitor.py b/tools/perf/scripts/python/net_dropmonitor.py
old mode 100755
new mode 100644
diff --git a/tools/perf/util/PERF-VERSION-GEN b/tools/perf/util/PERF-VERSION-GEN
old mode 100755
new mode 100644
diff --git a/tools/perf/util/generate-cmdlist.sh b/tools/perf/util/generate-cmdlist.sh
old mode 100755
new mode 100644
diff --git a/tools/power/cpupower/utils/version-gen.sh b/tools/power/cpupower/utils/version-gen.sh
old mode 100755
new mode 100644
diff --git a/tools/testing/ktest/compare-ktest-sample.pl b/tools/testing/ktest/compare-ktest-sample.pl
old mode 100755
new mode 100644
diff --git a/tools/testing/ktest/ktest.pl b/tools/testing/ktest/ktest.pl
old mode 100755
new mode 100644
-- 
1.8.3.1

