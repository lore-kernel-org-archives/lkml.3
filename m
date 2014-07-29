Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753729AbaG2MCn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 08:02:43 -0400
Received: from mail.mev.co.uk ([62.49.15.74]:51671 "EHLO mail.mev.co.uk"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbaG2L6p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 07:58:45 -0400
From: Ian Abbott <abbotti@mev.co.uk>
To: driverdev-devel@linuxdriverproject.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ian Abbott <abbotti@mev.co.uk>,
        H Hartley Sweeten <hartleys@visionengravers.com>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 07/19] staging: comedi: amplc_pci230: remove unused settling time constants
Date: Tue, 29 Jul 2014 12:58:15 +0100
Message-Id: <1406635107-27950-8-git-send-email-abbotti@mev.co.uk>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
References: <1406635107-27950-1-git-send-email-abbotti@mev.co.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The macro constants `PCI230_DAC_SETTLE`, `PCI230_ADC_SETTLE` and
`PCI230_MUX_SETTLE` are never used.  Just remove them.

Signed-off-by: Ian Abbott <abbotti@mev.co.uk>
---
 drivers/staging/comedi/drivers/amplc_pci230.c | 13 -------------
 1 file changed, 13 deletions(-)

diff --git a/drivers/staging/comedi/drivers/amplc_pci230.c b/drivers/staging/comedi/drivers/amplc_pci230.c
index 00d7a22..7983a0d 100644
--- a/drivers/staging/comedi/drivers/amplc_pci230.c
+++ b/drivers/staging/comedi/drivers/amplc_pci230.c
@@ -247,19 +247,6 @@
 #define PCI230P2_DACEN		0x06	/* DAC channel enable (FIFO mode) */
 
 /*
- * Convertor related constants.
- */
-/* Analogue output settling time in µs (DAC itself is 1µs nominally). */
-#define PCI230_DAC_SETTLE 5
-/*
- * Analogue input settling time in µs (ADC itself is 1.6µs nominally but we
- * poll anyway).
- */
-#define PCI230_ADC_SETTLE 1
-/* ADC MUX settling time in µS - 10µs for se, 20µs de. */
-#define PCI230_MUX_SETTLE 10
-
-/*
  * DACCON read-write values.
  */
 #define PCI230_DAC_OR_UNI		(0<<0)	/* Output range unipolar */
-- 
2.0.0

