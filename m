Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754769Ab3AaK4c (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 05:56:32 -0500
Received: from mail-wg0-f41.google.com ([74.125.82.41]:59893 "EHLO
	mail-wg0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753241Ab3AaK4a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 05:56:30 -0500
Date: Thu, 31 Jan 2013 11:56:48 +0100
From: Sebastiaan de Haan <sebastiaan@sebastiaandehaan.nl>
To: abbotti@mev.co.uk
Cc: fmhess@users.sourceforge.net, gregkh@linuxfoundation.org,
        hsweeten@visionengravers.com, sebastiaan@sebastiaandehaan.nl,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] Staging: comedi: made range.c checkpatch.pl compliant
Message-ID: <20130131105648.GB18894@f-lin01.localdomain>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Change made to range.c to make it checkpatch.pl compliant

Signed-off-by: Sebastiaan de Haan <sebastiaan@sebastiaandehaan.nl>
---
 drivers/staging/comedi/range.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/staging/comedi/range.c b/drivers/staging/comedi/range.c
index 59ff0cf..b87fb4e 100644
--- a/drivers/staging/comedi/range.c
+++ b/drivers/staging/comedi/range.c
@@ -35,7 +35,7 @@ const struct comedi_lrange range_unipolar10 = { 1, {UNI_RANGE(10)} };
 EXPORT_SYMBOL(range_unipolar10);
 const struct comedi_lrange range_unipolar5 = { 1, {UNI_RANGE(5)} };
 EXPORT_SYMBOL(range_unipolar5);
-const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_none} } };
+const struct comedi_lrange range_unknown = { 1, {{0, 1000000, UNIT_NONE} } };
 EXPORT_SYMBOL(range_unknown);
 
 /*
-- 
1.7.10.4

