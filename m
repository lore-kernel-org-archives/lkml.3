Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755245AbaLEXoJ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:44:09 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:53858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282AbaLEWqD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 17:46:03 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Axel Lin <axel.lin@ingics.com>, Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.17 051/122] iio: adc: men_z188_adc: Add terminating entry for men_z188_ids
Date: Fri,  5 Dec 2014 14:43:45 -0800
Message-Id: <20141205223313.256330697@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141205223305.514276242@linuxfoundation.org>
References: <20141205223305.514276242@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Axel Lin <axel.lin@ingics.com>

commit fbbba1f89eb68e7d07707e104193d56de8e37fe5 upstream.

The mcb_device_id table is supposed to be zero-terminated.

Signed-off-by: Axel Lin <axel.lin@ingics.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/adc/men_z188_adc.c |    1 +
 1 file changed, 1 insertion(+)

--- a/drivers/iio/adc/men_z188_adc.c
+++ b/drivers/iio/adc/men_z188_adc.c
@@ -152,6 +152,7 @@ static void men_z188_remove(struct mcb_d
 
 static const struct mcb_device_id men_z188_ids[] = {
 	{ .device = 0xbc },
+	{ }
 };
 MODULE_DEVICE_TABLE(mcb, men_z188_ids);
 


