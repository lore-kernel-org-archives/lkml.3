Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932354Ab3L3W2s (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 17:28:48 -0500
Received: from atrey.karlin.mff.cuni.cz ([195.113.26.193]:47804 "EHLO
	atrey.karlin.mff.cuni.cz" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932299Ab3L3W2r (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 17:28:47 -0500
Date: Mon, 30 Dec 2013 23:28:45 +0100
From: Pavel Machek <pavel@ucw.cz>
To: Marcel Holtmann <marcel@holtmann.org>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        =?utf-8?B?0JjQstCw0LnQu9C+INCU0LjQvNC40YLRgNC+0LI=?= 
	<freemangordon@abv.bg>,
        "Gustavo F. Padovan" <gustavo@padovan.org>,
        Johan Hedberg <johan.hedberg@gmail.com>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        "linux-bluetooth@vger.kernel.org development" 
	<linux-bluetooth@vger.kernel.org>,
        Ville Tervo <ville.tervo@nokia.com>, Sebastian Reichel <sre@ring0.de>
Subject: Re: [PATCH v2] Bluetooth: Add hci_h4p driver
Message-ID: <20131230222844.GC32561@amd.pavel.ucw.cz>
References: <1379703710-5757-1-git-send-email-pali.rohar@gmail.com>
 <1727897.LBX8128hIo@izba>
 <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <C8D1F470-7964-4EAC-82E0-D53CF54DE086@holtmann.org>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi!

> > +++ b/drivers/bluetooth/hci_h4p/core.c
> > @@ -0,0 +1,1357 @@
> > +/*
> > + * This file is part of hci_h4p bluetooth driver
> > + *
> > + * Copyright (C) 2005-2008 Nokia Corporation.
> > + *
> > + * Contact: Ville Tervo <ville.tervo@nokia.com>
> 
> I think you can just remove the contact names since I think nobody of the original authors is still working at Nokia and I bet this emails addresses just do not work anymore.
> 

What about this?

commit 3f18ca6cd02a13baf4be9beb89b1470ad1ce008c
Author: Pavel <pavel@ucw.cz>
Date:   Mon Dec 30 23:27:21 2013 +0100

    Update comments, remove no longer relevant contacts.

Signed-off-by: Pavel Machek <pavel@ucw.cz>

diff --git a/drivers/bluetooth/nokia_core.c b/drivers/bluetooth/nokia_core.c
index a91bd7b..6dbd3b7 100644
--- a/drivers/bluetooth/nokia_core.c
+++ b/drivers/bluetooth/nokia_core.c
@@ -1,10 +1,8 @@
 /*
- * This file is part of hci_h4p bluetooth driver
+ * This file is part of Nokia H4P bluetooth driver
  *
  * Copyright (C) 2005-2008 Nokia Corporation.
  *
- * Contact: Ville Tervo <ville.tervo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
@@ -19,6 +17,8 @@
  * Foundation, Inc., 51 Franklin St, Fifth Floor, Boston, MA
  * 02110-1301 USA
  *
+ * Thanks to all the Nokia people that helped with this driver,
+ * including Ville Tervo and Roger Quadros.
  */
 
 #include <linux/module.h>
diff --git a/drivers/bluetooth/nokia_fw-bcm.c b/drivers/bluetooth/nokia_fw-bcm.c
index 390d021..9c01a6a 100644
--- a/drivers/bluetooth/nokia_fw-bcm.c
+++ b/drivers/bluetooth/nokia_fw-bcm.c
@@ -1,10 +1,8 @@
 /*
- * This file is part of hci_h4p bluetooth driver
+ * This file is part of Nokia H4P bluetooth driver
  *
  * Copyright (C) 2005-2008 Nokia Corporation.
  *
- * Contact: Ville Tervo <ville.tervo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/bluetooth/nokia_fw-csr.c b/drivers/bluetooth/nokia_fw-csr.c
index af880d9..23c5fc5 100644
--- a/drivers/bluetooth/nokia_fw-csr.c
+++ b/drivers/bluetooth/nokia_fw-csr.c
@@ -1,10 +1,8 @@
 /*
- * This file is part of hci_h4p bluetooth driver
+ * This file is part of Nokia H4P bluetooth driver
  *
  * Copyright (C) 2005-2008 Nokia Corporation.
  *
- * Contact: Ville Tervo <ville.tervo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/bluetooth/nokia_fw-ti1273.c b/drivers/bluetooth/nokia_fw-ti1273.c
index 32e5fa0..2825504 100644
--- a/drivers/bluetooth/nokia_fw-ti1273.c
+++ b/drivers/bluetooth/nokia_fw-ti1273.c
@@ -1,10 +1,8 @@
 /*
- * This file is part of hci_h4p bluetooth driver
+ * This file is part of Nokia H4P bluetooth driver
  *
  * Copyright (C) 2009 Nokia Corporation.
  *
- * Contact: Ville Tervo <ville.tervo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/drivers/bluetooth/nokia_uart.c b/drivers/bluetooth/nokia_uart.c
index 8e0a93c..fd94a98 100644
--- a/drivers/bluetooth/nokia_uart.c
+++ b/drivers/bluetooth/nokia_uart.c
@@ -1,10 +1,8 @@
 /*
- * This file is part of hci_h4p bluetooth driver
+ * This file is part of Nokia H4P bluetooth driver
  *
  * Copyright (C) 2005, 2006 Nokia Corporation.
  *
- * Contact: Ville Tervo <ville.tervo@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.
diff --git a/include/linux/bluetooth/hci_h4p.h b/include/linux/bluetooth/hci_h4p.h
index daf83fc..30d169d 100644
--- a/include/linux/bluetooth/hci_h4p.h
+++ b/include/linux/bluetooth/hci_h4p.h
@@ -1,10 +1,8 @@
 /*
- * This file is part of hci_h4p bluetooth driver
+ * This file is part of Nokia H4P bluetooth driver
  *
  * Copyright (C) 2010 Nokia Corporation.
  *
- * Contact: Roger Quadros <roger.quadros@nokia.com>
- *
  * This program is free software; you can redistribute it and/or
  * modify it under the terms of the GNU General Public License
  * version 2 as published by the Free Software Foundation.


-- 
(english) http://www.livejournal.com/~pavelmachek
(cesky, pictures) http://atrey.karlin.mff.cuni.cz/~pavel/picture/horses/blog.html
