Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756921Ab3FKUGQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Jun 2013 16:06:16 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:42065 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756844Ab3FKUEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Jun 2013 16:04:20 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Hennerich <michael.hennerich@analog.com>,
        Jonathan Cameron <jic23@kernel.org>,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [ 68/79] iio:inkern: Fix typo/bug in convert raw to processed.
Date: Tue, 11 Jun 2013 13:03:34 -0700
Message-Id: <20130611195324.984549968@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.254.g5578ad7
In-Reply-To: <20130611195312.352656079@linuxfoundation.org>
References: <20130611195312.352656079@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Hennerich <michael.hennerich@analog.com>

commit 6c5d4c96f979611f0165dc825af9e1cea8dd35b9 upstream.

Signed-off-by: Michael Hennerich <michael.hennerich@analog.com>
Signed-off-by: Jonathan Cameron <jic23@kernel.org>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/iio/inkern.c |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

--- a/drivers/iio/inkern.c
+++ b/drivers/iio/inkern.c
@@ -279,7 +279,7 @@ static int iio_convert_raw_to_processed_
 	s64 raw64 = raw;
 	int ret;
 
-	ret = iio_channel_read(chan, &offset, NULL, IIO_CHAN_INFO_SCALE);
+	ret = iio_channel_read(chan, &offset, NULL, IIO_CHAN_INFO_OFFSET);
 	if (ret == 0)
 		raw64 += offset;
 


