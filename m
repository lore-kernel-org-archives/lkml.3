Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470AbaKLB3g (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:29:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59153 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932733AbaKLB31 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:29:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        George McCollister <george.mccollister@gmail.com>,
        Hartmut Knaack <knaack.h@gmx.de>, Jonathan Cameron <jic23@kernel.org>
Subject: [PATCH 3.17 192/319] iio: as3935: allocate correct iio_device size
Date: Wed, 12 Nov 2014 10:15:30 +0900
Message-Id: <20141112011024.516804460@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: George McCollister <george.mccollister@gmail.com>

commit f73cde600d410ad4b31362a9c348016e40a146ea upstream.

Signed-off-by: George McCollister <george.mccollister@gmail.com>
Acked-by: Hartmut Knaack <knaack.h@gmx.de>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/proximity/as3935.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/proximity/as3935.c
+++ b/drivers/iio/proximity/as3935.c
@@ -330,7 +330,7 @@ static int as3935_probe(struct spi_devic
 		return -EINVAL;
 	}
 
-	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(st));
+	indio_dev = devm_iio_device_alloc(&spi->dev, sizeof(*st));
 	if (!indio_dev)
 		return -ENOMEM;
 


