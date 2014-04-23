Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757959AbaDWTEY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 15:04:24 -0400
Received: from mail1.bemta8.messagelabs.com ([216.82.243.200]:44155 "EHLO
	mail1.bemta8.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757680AbaDWTEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 15:04:21 -0400
X-Env-Sender: Benjamin.Romer@unisys.com
X-Msg-Ref: server-11.tower-45.messagelabs.com!1398279856!35948541!7
X-Originating-IP: [192.61.61.104]
X-StarScan-Received: 
X-StarScan-Version: 6.11.1; banners=-,-,-
X-VirusChecked: Checked
From: Benjamin Romer <benjamin.romer@unisys.com>
To: <gregkh@linuxfoundation.org>, <sparmaintainer@unisys.com>,
        <linux-kernel@vger.kernel.org>, <jkc@redhat.com>,
        <devel@driverdev.osuosl.org>
CC: Benjamin Romer <benjamin.romer@unisys.com>
Subject: [PATCH] staging: unisys: fix copyright notices
Date: Wed, 23 Apr 2014 14:58:34 -0400
Message-ID: <1398279514-16533-1-git-send-email-benjamin.romer@unisys.com>
X-Mailer: git-send-email 1.9.1
MIME-Version: 1.0
Content-Type: text/plain; charset="UTF-8"
Content-Transfer-Encoding: 8bit
X-OriginalArrivalTime: 23 Apr 2014 19:03:32.0990 (UTC) FILETIME=[B8BE29E0:01CF5F26]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch changes all of the various representations of the copyright symbol
to (C).

Signed-off-by: Benjamin Romer <benjamin.romer@unisys.com>
---
 drivers/staging/unisys/channels/channel.c                               | 2 +-
 drivers/staging/unisys/channels/chanstub.c                              | 2 +-
 drivers/staging/unisys/channels/chanstub.h                              | 2 +-
 drivers/staging/unisys/common-spar/include/channels/channel.h           | 2 +-
 drivers/staging/unisys/common-spar/include/channels/channel_guid.h      | 2 +-
 drivers/staging/unisys/common-spar/include/channels/controlframework.h  | 2 +-
 drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h  | 2 +-
 drivers/staging/unisys/common-spar/include/channels/diagchannel.h       | 2 +-
 drivers/staging/unisys/common-spar/include/channels/iochannel.h         | 2 +-
 drivers/staging/unisys/common-spar/include/channels/vbuschannel.h       | 2 +-
 drivers/staging/unisys/common-spar/include/controlvmcompletionstatus.h  | 2 +-
 .../staging/unisys/common-spar/include/diagnostics/appos_subsystems.h   | 2 +-
 drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h              | 2 +-
 drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h             | 2 +-
 drivers/staging/unisys/common-spar/include/version.h                    | 2 +-
 drivers/staging/unisys/common-spar/include/vmcallinterface.h            | 2 +-
 drivers/staging/unisys/include/commontypes.h                            | 2 +-
 drivers/staging/unisys/include/guestlinuxdebug.h                        | 2 +-
 drivers/staging/unisys/include/guidutils.h                              | 2 +-
 drivers/staging/unisys/include/periodic_work.h                          | 2 +-
 drivers/staging/unisys/include/procobjecttree.h                         | 2 +-
 drivers/staging/unisys/include/sparstop.h                               | 2 +-
 drivers/staging/unisys/include/timskmod.h                               | 2 +-
 drivers/staging/unisys/include/timskmodutils.h                          | 2 +-
 drivers/staging/unisys/include/uisqueue.h                               | 2 +-
 drivers/staging/unisys/include/uisthread.h                              | 2 +-
 drivers/staging/unisys/include/uisutils.h                               | 2 +-
 drivers/staging/unisys/include/uniklog.h                                | 2 +-
 drivers/staging/unisys/uislib/uislib.c                                  | 2 +-
 drivers/staging/unisys/uislib/uisqueue.c                                | 2 +-
 drivers/staging/unisys/uislib/uisthread.c                               | 2 +-
 drivers/staging/unisys/uislib/uisutils.c                                | 2 +-
 drivers/staging/unisys/virthba/virthba.c                                | 2 +-
 drivers/staging/unisys/virthba/virthba.h                                | 2 +-
 drivers/staging/unisys/virtpci/virtpci.c                                | 2 +-
 drivers/staging/unisys/virtpci/virtpci.h                                | 2 +-
 drivers/staging/unisys/visorchannel/globals.h                           | 2 +-
 drivers/staging/unisys/visorchannel/visorchannel.h                      | 2 +-
 drivers/staging/unisys/visorchannel/visorchannel_funcs.c                | 2 +-
 drivers/staging/unisys/visorchannel/visorchannel_main.c                 | 2 +-
 drivers/staging/unisys/visorchipset/controlvm.h                         | 2 +-
 drivers/staging/unisys/visorchipset/controlvm_direct.c                  | 2 +-
 drivers/staging/unisys/visorchipset/file.c                              | 2 +-
 drivers/staging/unisys/visorchipset/file.h                              | 2 +-
 drivers/staging/unisys/visorchipset/globals.h                           | 2 +-
 drivers/staging/unisys/visorchipset/parser.c                            | 2 +-
 drivers/staging/unisys/visorchipset/parser.h                            | 2 +-
 drivers/staging/unisys/visorchipset/testing.h                           | 2 +-
 drivers/staging/unisys/visorchipset/visorchipset.h                      | 2 +-
 drivers/staging/unisys/visorchipset/visorchipset_main.c                 | 2 +-
 drivers/staging/unisys/visorchipset/visorchipset_umode.h                | 2 +-
 drivers/staging/unisys/visorutil/charqueue.c                            | 2 +-
 drivers/staging/unisys/visorutil/charqueue.h                            | 2 +-
 drivers/staging/unisys/visorutil/easyproc.c                             | 2 +-
 drivers/staging/unisys/visorutil/easyproc.h                             | 2 +-
 drivers/staging/unisys/visorutil/memregion.h                            | 2 +-
 drivers/staging/unisys/visorutil/memregion_direct.c                     | 2 +-
 drivers/staging/unisys/visorutil/periodic_work.c                        | 2 +-
 drivers/staging/unisys/visorutil/procobjecttree.c                       | 2 +-
 drivers/staging/unisys/visorutil/visorkmodutils.c                       | 2 +-
 60 files changed, 60 insertions(+), 60 deletions(-)

diff --git a/drivers/staging/unisys/channels/channel.c b/drivers/staging/unisys/channels/channel.c
index f645259..7223a14 100644
--- a/drivers/staging/unisys/channels/channel.c
+++ b/drivers/staging/unisys/channels/channel.c
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/channels/chanstub.c b/drivers/staging/unisys/channels/chanstub.c
index f504f49..45ac55d 100644
--- a/drivers/staging/unisys/channels/chanstub.c
+++ b/drivers/staging/unisys/channels/chanstub.c
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/channels/chanstub.h b/drivers/staging/unisys/channels/chanstub.h
index 8d727de..bdee5d5 100644
--- a/drivers/staging/unisys/channels/chanstub.h
+++ b/drivers/staging/unisys/channels/chanstub.h
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/channels/channel.h b/drivers/staging/unisys/common-spar/include/channels/channel.h
index aee2041..d829864 100644
--- a/drivers/staging/unisys/common-spar/include/channels/channel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/channel.h
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/channels/channel_guid.h b/drivers/staging/unisys/common-spar/include/channels/channel_guid.h
index ae0dc2b..1f1f48e 100644
--- a/drivers/staging/unisys/common-spar/include/channels/channel_guid.h
+++ b/drivers/staging/unisys/common-spar/include/channels/channel_guid.h
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/channels/controlframework.h b/drivers/staging/unisys/common-spar/include/channels/controlframework.h
index 5126433..1a1c505 100644
--- a/drivers/staging/unisys/common-spar/include/channels/controlframework.h
+++ b/drivers/staging/unisys/common-spar/include/channels/controlframework.h
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h b/drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h
index 47f1c4f..17beec2 100644
--- a/drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/controlvmchannel.h
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/channels/diagchannel.h b/drivers/staging/unisys/common-spar/include/channels/diagchannel.h
index c93515e..daf3096 100644
--- a/drivers/staging/unisys/common-spar/include/channels/diagchannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/diagchannel.h
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/channels/iochannel.h b/drivers/staging/unisys/common-spar/include/channels/iochannel.h
index 8de1d24..8141d63 100644
--- a/drivers/staging/unisys/common-spar/include/channels/iochannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/iochannel.h
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION */
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION */
 /* All rights reserved. */
 #ifndef __IOCHANNEL_H__
 #define __IOCHANNEL_H__
diff --git a/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h b/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
index 99dbbcf..7643042 100644
--- a/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
+++ b/drivers/staging/unisys/common-spar/include/channels/vbuschannel.h
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/controlvmcompletionstatus.h b/drivers/staging/unisys/common-spar/include/controlvmcompletionstatus.h
index de30d32..db77d6f 100644
--- a/drivers/staging/unisys/common-spar/include/controlvmcompletionstatus.h
+++ b/drivers/staging/unisys/common-spar/include/controlvmcompletionstatus.h
@@ -1,6 +1,6 @@
 /* controlvmcompletionstatus.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All Rights Reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/diagnostics/appos_subsystems.h b/drivers/staging/unisys/common-spar/include/diagnostics/appos_subsystems.h
index 4c6294d..18cc9ed 100644
--- a/drivers/staging/unisys/common-spar/include/diagnostics/appos_subsystems.h
+++ b/drivers/staging/unisys/common-spar/include/diagnostics/appos_subsystems.h
@@ -1,4 +1,4 @@
-/* Copyright © 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h b/drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h
index 7304e9a0..fe9598c 100644
--- a/drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h
+++ b/drivers/staging/unisys/common-spar/include/iovmcall_gnuc.h
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h b/drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h
index ae708fa..8c0259a 100644
--- a/drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h
+++ b/drivers/staging/unisys/common-spar/include/vbusdeviceinfo.h
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/version.h b/drivers/staging/unisys/common-spar/include/version.h
index 00b0ebb..f25208f 100644
--- a/drivers/staging/unisys/common-spar/include/version.h
+++ b/drivers/staging/unisys/common-spar/include/version.h
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/common-spar/include/vmcallinterface.h b/drivers/staging/unisys/common-spar/include/vmcallinterface.h
index 14c4043..c5c10f3 100644
--- a/drivers/staging/unisys/common-spar/include/vmcallinterface.h
+++ b/drivers/staging/unisys/common-spar/include/vmcallinterface.h
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/commontypes.h b/drivers/staging/unisys/include/commontypes.h
index ef12af4..ea02ef4 100644
--- a/drivers/staging/unisys/include/commontypes.h
+++ b/drivers/staging/unisys/include/commontypes.h
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/guestlinuxdebug.h b/drivers/staging/unisys/include/guestlinuxdebug.h
index c3de849..3c1e462 100644
--- a/drivers/staging/unisys/include/guestlinuxdebug.h
+++ b/drivers/staging/unisys/include/guestlinuxdebug.h
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/guidutils.h b/drivers/staging/unisys/include/guidutils.h
index 75caf92..adeb92d 100644
--- a/drivers/staging/unisys/include/guidutils.h
+++ b/drivers/staging/unisys/include/guidutils.h
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/periodic_work.h b/drivers/staging/unisys/include/periodic_work.h
index 6c7190b..418ba63 100644
--- a/drivers/staging/unisys/include/periodic_work.h
+++ b/drivers/staging/unisys/include/periodic_work.h
@@ -1,6 +1,6 @@
 /* periodic_work.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/procobjecttree.h b/drivers/staging/unisys/include/procobjecttree.h
index c81d112..1174056 100644
--- a/drivers/staging/unisys/include/procobjecttree.h
+++ b/drivers/staging/unisys/include/procobjecttree.h
@@ -1,6 +1,6 @@
 /* procobjecttree.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/sparstop.h b/drivers/staging/unisys/include/sparstop.h
index 3603ac6..0583739 100644
--- a/drivers/staging/unisys/include/sparstop.h
+++ b/drivers/staging/unisys/include/sparstop.h
@@ -1,6 +1,6 @@
 /* sparstop.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/timskmod.h b/drivers/staging/unisys/include/timskmod.h
index 5fd5ad5..ecf1a6f 100644
--- a/drivers/staging/unisys/include/timskmod.h
+++ b/drivers/staging/unisys/include/timskmod.h
@@ -1,6 +1,6 @@
 /* timskmod.h
  *
- * Copyright ï¿½ 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/timskmodutils.h b/drivers/staging/unisys/include/timskmodutils.h
index 2d81d46..0045d55 100644
--- a/drivers/staging/unisys/include/timskmodutils.h
+++ b/drivers/staging/unisys/include/timskmodutils.h
@@ -1,6 +1,6 @@
 /* timskmodutils.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/uisqueue.h b/drivers/staging/unisys/include/uisqueue.h
index 6dab390..d7793a8 100644
--- a/drivers/staging/unisys/include/uisqueue.h
+++ b/drivers/staging/unisys/include/uisqueue.h
@@ -1,6 +1,6 @@
 /* uisqueue.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/uisthread.h b/drivers/staging/unisys/include/uisthread.h
index 2b1fba7..2683777 100644
--- a/drivers/staging/unisys/include/uisthread.h
+++ b/drivers/staging/unisys/include/uisthread.h
@@ -1,6 +1,6 @@
 /* uisthread.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/uisutils.h b/drivers/staging/unisys/include/uisutils.h
index 5fdab3a..f4774c0 100644
--- a/drivers/staging/unisys/include/uisutils.h
+++ b/drivers/staging/unisys/include/uisutils.h
@@ -1,6 +1,6 @@
 /* uisutils.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/include/uniklog.h b/drivers/staging/unisys/include/uniklog.h
index 4d7b87c..6178cc4 100644
--- a/drivers/staging/unisys/include/uniklog.h
+++ b/drivers/staging/unisys/include/uniklog.h
@@ -1,6 +1,6 @@
 /* uniklog.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/uislib/uislib.c b/drivers/staging/unisys/uislib/uislib.c
index 3152a21..0e1a58a 100644
--- a/drivers/staging/unisys/uislib/uislib.c
+++ b/drivers/staging/unisys/uislib/uislib.c
@@ -1,6 +1,6 @@
 /* uislib.c
  *
- * Copyright ï¿½ 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/uislib/uisqueue.c b/drivers/staging/unisys/uislib/uisqueue.c
index 40598ff..d4a6074 100644
--- a/drivers/staging/unisys/uislib/uisqueue.c
+++ b/drivers/staging/unisys/uislib/uisqueue.c
@@ -1,6 +1,6 @@
 /* uisqueue.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/uislib/uisthread.c b/drivers/staging/unisys/uislib/uisthread.c
index 782b06a..c93ab04 100644
--- a/drivers/staging/unisys/uislib/uisthread.c
+++ b/drivers/staging/unisys/uislib/uisthread.c
@@ -1,6 +1,6 @@
 /* uisthread.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/uislib/uisutils.c b/drivers/staging/unisys/uislib/uisutils.c
index 3178f75..b49647c 100644
--- a/drivers/staging/unisys/uislib/uisutils.c
+++ b/drivers/staging/unisys/uislib/uisutils.c
@@ -1,6 +1,6 @@
 /* uisutils.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/virthba/virthba.c b/drivers/staging/unisys/virthba/virthba.c
index 817b11d..d4bfc00 100644
--- a/drivers/staging/unisys/virthba/virthba.c
+++ b/drivers/staging/unisys/virthba/virthba.c
@@ -1,6 +1,6 @@
 /* virthba.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/virthba/virthba.h b/drivers/staging/unisys/virthba/virthba.h
index 88b7974..d4b809b 100644
--- a/drivers/staging/unisys/virthba/virthba.h
+++ b/drivers/staging/unisys/virthba/virthba.h
@@ -1,6 +1,6 @@
 /* virthba.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/virtpci/virtpci.c b/drivers/staging/unisys/virtpci/virtpci.c
index 8e34650..21f8bd5 100644
--- a/drivers/staging/unisys/virtpci/virtpci.c
+++ b/drivers/staging/unisys/virtpci/virtpci.c
@@ -1,6 +1,6 @@
 /* virtpci.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/virtpci/virtpci.h b/drivers/staging/unisys/virtpci/virtpci.h
index b8fd07b..b695c4b 100644
--- a/drivers/staging/unisys/virtpci/virtpci.h
+++ b/drivers/staging/unisys/virtpci/virtpci.h
@@ -1,6 +1,6 @@
 /* virtpci.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchannel/globals.h b/drivers/staging/unisys/visorchannel/globals.h
index 668f832..07653b8 100644
--- a/drivers/staging/unisys/visorchannel/globals.h
+++ b/drivers/staging/unisys/visorchannel/globals.h
@@ -1,6 +1,6 @@
 /* globals.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchannel/visorchannel.h b/drivers/staging/unisys/visorchannel/visorchannel.h
index 62d29a2..a8c2ebd 100644
--- a/drivers/staging/unisys/visorchannel/visorchannel.h
+++ b/drivers/staging/unisys/visorchannel/visorchannel.h
@@ -1,6 +1,6 @@
 /* visorchannel.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchannel/visorchannel_funcs.c b/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
index 0536816..4427d01 100644
--- a/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
+++ b/drivers/staging/unisys/visorchannel/visorchannel_funcs.c
@@ -1,6 +1,6 @@
 /* visorchannel_funcs.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchannel/visorchannel_main.c b/drivers/staging/unisys/visorchannel/visorchannel_main.c
index 482ee0a..1a09257 100644
--- a/drivers/staging/unisys/visorchannel/visorchannel_main.c
+++ b/drivers/staging/unisys/visorchannel/visorchannel_main.c
@@ -1,6 +1,6 @@
 /* visorchannel_main.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/controlvm.h b/drivers/staging/unisys/visorchipset/controlvm.h
index 873fa12..012891c 100644
--- a/drivers/staging/unisys/visorchipset/controlvm.h
+++ b/drivers/staging/unisys/visorchipset/controlvm.h
@@ -1,6 +1,6 @@
 /* controlvm.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/controlvm_direct.c b/drivers/staging/unisys/visorchipset/controlvm_direct.c
index b911ea8..cd10e3a 100644
--- a/drivers/staging/unisys/visorchipset/controlvm_direct.c
+++ b/drivers/staging/unisys/visorchipset/controlvm_direct.c
@@ -1,6 +1,6 @@
 /* controlvm_direct.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/file.c b/drivers/staging/unisys/visorchipset/file.c
index e214a11..fccc4f0 100644
--- a/drivers/staging/unisys/visorchipset/file.c
+++ b/drivers/staging/unisys/visorchipset/file.c
@@ -1,6 +1,6 @@
 /* file.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/file.h b/drivers/staging/unisys/visorchipset/file.h
index 597282a..21bb906 100644
--- a/drivers/staging/unisys/visorchipset/file.h
+++ b/drivers/staging/unisys/visorchipset/file.h
@@ -1,6 +1,6 @@
 /* file.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/globals.h b/drivers/staging/unisys/visorchipset/globals.h
index a0e6d4f..0fe1459 100644
--- a/drivers/staging/unisys/visorchipset/globals.h
+++ b/drivers/staging/unisys/visorchipset/globals.h
@@ -1,6 +1,6 @@
 /* globals.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/parser.c b/drivers/staging/unisys/visorchipset/parser.c
index b408d41..948fbb8 100644
--- a/drivers/staging/unisys/visorchipset/parser.c
+++ b/drivers/staging/unisys/visorchipset/parser.c
@@ -1,6 +1,6 @@
 /* parser.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/parser.h b/drivers/staging/unisys/visorchipset/parser.h
index a0cc50a..3e4aedc 100644
--- a/drivers/staging/unisys/visorchipset/parser.h
+++ b/drivers/staging/unisys/visorchipset/parser.h
@@ -1,6 +1,6 @@
 /* parser.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/testing.h b/drivers/staging/unisys/visorchipset/testing.h
index a44f555..ad378b8 100644
--- a/drivers/staging/unisys/visorchipset/testing.h
+++ b/drivers/staging/unisys/visorchipset/testing.h
@@ -1,6 +1,6 @@
 /* testing.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/visorchipset.h b/drivers/staging/unisys/visorchipset/visorchipset.h
index d95825d..06646e4 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset.h
+++ b/drivers/staging/unisys/visorchipset/visorchipset.h
@@ -1,6 +1,6 @@
 /* visorchipset.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/visorchipset_main.c b/drivers/staging/unisys/visorchipset/visorchipset_main.c
index c475e25..1895dc4 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_main.c
+++ b/drivers/staging/unisys/visorchipset/visorchipset_main.c
@@ -1,6 +1,6 @@
 /* visorchipset_main.c
  *
- * Copyright ï¿½ 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorchipset/visorchipset_umode.h b/drivers/staging/unisys/visorchipset/visorchipset_umode.h
index 259e840..06ba5b7 100644
--- a/drivers/staging/unisys/visorchipset/visorchipset_umode.h
+++ b/drivers/staging/unisys/visorchipset/visorchipset_umode.h
@@ -1,6 +1,6 @@
 /* visorchipset_umode.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/charqueue.c b/drivers/staging/unisys/visorutil/charqueue.c
index 0ceede1..61600e1 100644
--- a/drivers/staging/unisys/visorutil/charqueue.c
+++ b/drivers/staging/unisys/visorutil/charqueue.c
@@ -1,6 +1,6 @@
 /* charqueue.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/charqueue.h b/drivers/staging/unisys/visorutil/charqueue.h
index e82ae0b..d6f1658 100644
--- a/drivers/staging/unisys/visorutil/charqueue.h
+++ b/drivers/staging/unisys/visorutil/charqueue.h
@@ -1,6 +1,6 @@
 /* charqueue.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/easyproc.c b/drivers/staging/unisys/visorutil/easyproc.c
index 60b6b83..43df598 100644
--- a/drivers/staging/unisys/visorutil/easyproc.c
+++ b/drivers/staging/unisys/visorutil/easyproc.c
@@ -1,4 +1,4 @@
-/* Copyright Â© 2010 - 2013 UNISYS CORPORATION
+/* Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/easyproc.h b/drivers/staging/unisys/visorutil/easyproc.h
index 1cef1fd..6ce7d5e 100644
--- a/drivers/staging/unisys/visorutil/easyproc.h
+++ b/drivers/staging/unisys/visorutil/easyproc.h
@@ -1,6 +1,6 @@
 /* easyproc.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/memregion.h b/drivers/staging/unisys/visorutil/memregion.h
index bb122db..7966316 100644
--- a/drivers/staging/unisys/visorutil/memregion.h
+++ b/drivers/staging/unisys/visorutil/memregion.h
@@ -1,6 +1,6 @@
 /* memregion.h
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/memregion_direct.c b/drivers/staging/unisys/visorutil/memregion_direct.c
index 2c1061d..d39fde9 100644
--- a/drivers/staging/unisys/visorutil/memregion_direct.c
+++ b/drivers/staging/unisys/visorutil/memregion_direct.c
@@ -1,6 +1,6 @@
 /* memregion_direct.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/periodic_work.c b/drivers/staging/unisys/visorutil/periodic_work.c
index 0670a31..0251b83 100644
--- a/drivers/staging/unisys/visorutil/periodic_work.c
+++ b/drivers/staging/unisys/visorutil/periodic_work.c
@@ -1,6 +1,6 @@
 /* periodic_work.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/procobjecttree.c b/drivers/staging/unisys/visorutil/procobjecttree.c
index 67a19e1..2f874e0 100644
--- a/drivers/staging/unisys/visorutil/procobjecttree.c
+++ b/drivers/staging/unisys/visorutil/procobjecttree.c
@@ -1,6 +1,6 @@
 /* procobjecttree.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
diff --git a/drivers/staging/unisys/visorutil/visorkmodutils.c b/drivers/staging/unisys/visorutil/visorkmodutils.c
index a7d1e94..e802e75 100644
--- a/drivers/staging/unisys/visorutil/visorkmodutils.c
+++ b/drivers/staging/unisys/visorutil/visorkmodutils.c
@@ -1,6 +1,6 @@
 /* timskmodutils.c
  *
- * Copyright © 2010 - 2013 UNISYS CORPORATION
+ * Copyright (C) 2010 - 2013 UNISYS CORPORATION
  * All rights reserved.
  *
  * This program is free software; you can redistribute it and/or modify
-- 
1.9.1

