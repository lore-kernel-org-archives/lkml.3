Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755904AbaG3CHE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jul 2014 22:07:04 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60467 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754941AbaG3Btk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jul 2014 21:49:40 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Hans Verkuil <hans.verkuil@cisco.com>,
        Mauro Carvalho Chehab <m.chehab@samsung.com>
Subject: [PATCH 3.14 02/29] media: media: v4l2-core: v4l2-dv-timings.c: Cleaning up code wrong value used in aspect ratio
Date: Tue, 29 Jul 2014 18:48:37 -0700
Message-Id: <20140730014809.411128491@linuxfoundation.org>
X-Mailer: git-send-email 2.0.3
In-Reply-To: <20140730014809.316066303@linuxfoundation.org>
References: <20140730014809.316066303@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>

commit f71920efb1066d71d74811e1dbed658173adf9bf upstream.

Wrong value used in same cases for the aspect ratio.

Signed-off-by: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
Acked-by: Lad, Prabhakar <prabhakar.csengg@gmail.com>
Signed-off-by: Hans Verkuil <hans.verkuil@cisco.com>
Signed-off-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/media/v4l2-core/v4l2-dv-timings.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

--- a/drivers/media/v4l2-core/v4l2-dv-timings.c
+++ b/drivers/media/v4l2-core/v4l2-dv-timings.c
@@ -595,10 +595,10 @@ struct v4l2_fract v4l2_calc_aspect_ratio
 		aspect.denominator = 9;
 	} else if (ratio == 34) {
 		aspect.numerator = 4;
-		aspect.numerator = 3;
+		aspect.denominator = 3;
 	} else if (ratio == 68) {
 		aspect.numerator = 15;
-		aspect.numerator = 9;
+		aspect.denominator = 9;
 	} else {
 		aspect.numerator = hor_landscape + 99;
 		aspect.denominator = 100;


