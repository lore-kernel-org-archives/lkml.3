Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934681AbaBDVMb (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 16:12:31 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:57236 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934520AbaBDVLw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 16:11:52 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Philip Pokorny <ppokorny@penguincomputing.com>,
        Guenter Roeck <linux@roeck-us.net>
Subject: [PATCH 3.13 061/140] hwmon: (k10temp) Add support for Kaveri CPUs
Date: Tue,  4 Feb 2014 13:10:48 -0800
Message-Id: <20140204211038.704383459@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20140204211036.967663852@linuxfoundation.org>
References: <20140204211036.967663852@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Phil Pokorny <ppokorny@penguincomputing.com>

commit d303b1b5fbb688282bbf72a534b9dfed7af9fe4f upstream.

Add new PCI ID to support new model "Kaveri" family.

Signed-off-by: Philip Pokorny <ppokorny@penguincomputing.com>
Signed-off-by: Guenter Roeck <linux@roeck-us.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/hwmon/k10temp.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/hwmon/k10temp.c
+++ b/drivers/hwmon/k10temp.c
@@ -210,6 +210,7 @@ static DEFINE_PCI_DEVICE_TABLE(k10temp_i
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_CNB17H_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M10H_F3) },
+	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_15H_M30H_NB_F3) },
 	{ PCI_VDEVICE(AMD, PCI_DEVICE_ID_AMD_16H_NB_F3) },
 	{}
 };


