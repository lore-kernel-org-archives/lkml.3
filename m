Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761281AbbA1UjE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:39:04 -0500
Received: from nblzone-211-213.nblnetworks.fi ([83.145.211.213]:49752 "EHLO
	hillosipuli.retiisi.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756491AbbA1Ui6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:38:58 -0500
Date: Wed, 28 Jan 2015 10:52:53 +0200
From: Sakari Ailus <sakari.ailus@iki.fi>
To: Jacek Anaszewski <j.anaszewski@samsung.com>
Cc: Lee Jones <lee.jones@linaro.org>, linux-leds@vger.kernel.org,
        linux-media@vger.kernel.org, linux-kernel@vger.kernel.org,
        devicetree@vger.kernel.org, kyungmin.park@samsung.com,
        b.zolnierkie@samsung.com, pavel@ucw.cz, cooloney@gmail.com,
        rpurdie@rpsys.net, s.nawrocki@samsung.com,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [PATCH/RFC v10 04/19] dt-binding: mfd: max77693: Add DT binding
 related macros
Message-ID: <20150128085253.GL17565@valkosipuli.retiisi.org.uk>
References: <1420816989-1808-1-git-send-email-j.anaszewski@samsung.com>
 <1420816989-1808-5-git-send-email-j.anaszewski@samsung.com>
 <20150120111243.GC13701@x1>
 <54BE4FB1.3030209@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <54BE4FB1.3030209@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jacek,

On Tue, Jan 20, 2015 at 01:53:05PM +0100, Jacek Anaszewski wrote:
> On 01/20/2015 12:12 PM, Lee Jones wrote:
> >On Fri, 09 Jan 2015, Jacek Anaszewski wrote:
> >
> >>Add macros for max77693 led part related binding.
> >>
> >>Signed-off-by: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
> >>Cc: Lee Jones <lee.jones@linaro.org>
> >>Cc: Chanwoo Choi <cw00.choi@samsung.com>
> >>---
> >>  include/dt-bindings/mfd/max77693.h |   21 +++++++++++++++++++++
> >>  1 file changed, 21 insertions(+)
> >>  create mode 100644 include/dt-bindings/mfd/max77693.h
> >>
> >>diff --git a/include/dt-bindings/mfd/max77693.h b/include/dt-bindings/mfd/max77693.h
> >>new file mode 100644
> >>index 0000000..f53e197
> >>--- /dev/null
> >>+++ b/include/dt-bindings/mfd/max77693.h
> >>@@ -0,0 +1,21 @@
> >>+/*
> >>+ * This header provides macros for MAX77693 device binding
> >>+ *
> >>+ * Copyright (C) 2014, Samsung Electronics Co., Ltd.
> >>+ *
> >>+ * Author: Jacek Anaszewski <j.anaszewski@samsung.com>
> >>+ */
> >>+
> >>+#ifndef __DT_BINDINGS_MAX77693_H__
> >>+#define __DT_BINDINGS_MAX77693_H
> >>+
> >>+/* External trigger type */
> >>+#define MAX77693_LED_TRIG_TYPE_EDGE	0
> >>+#define MAX77693_LED_TRIG_TYPE_LEVEL	1
> >>+
> >>+/* Boost modes */
> >>+#define MAX77693_LED_BOOST_OFF		0
> >>+#define MAX77693_LED_BOOST_ADAPTIVE	1
> >>+#define MAX77693_LED_BOOST_FIXED	2
> >>+
> >>+#endif /* __DT_BINDINGS_MAX77693_H */
> >
> >These look fairly generic.  Do generic LED defines already exist?  If
> >not, can they?
> 
> I am not entirely sure that they are generic. Different devices
> may define different trigger types for low current LEDs and flash
> LEDs. Boost modes could also have different semantics.
> 
> Regardless of the above we can consider renaming the file to
> include/dt-bindings/leds/max77693.h
> 
> Bryan - what is your opinion?

At least trigger type can be chosen for lm3555 (as3645a) as well. I'm not
sure about boost mode.

-- 
Regards,

Sakari Ailus
e-mail: sakari.ailus@iki.fi	XMPP: sailus@retiisi.org.uk
