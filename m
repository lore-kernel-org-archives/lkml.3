Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754662AbaFNLgN (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Jun 2014 07:36:13 -0400
Received: from mail-wi0-f173.google.com ([209.85.212.173]:36358 "EHLO
	mail-wi0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753746AbaFNLgM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Jun 2014 07:36:12 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Mauro Carvalho Chehab <m.chehab@samsung.com>,
        Hans Verkuil <hans.verkuil@cisco.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        "Lad, Prabhakar" <prabhakar.csengg@gmail.com>,
        Martin Bugge <marbugge@cisco.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2] media: v4l2-core: v4l2-dv-timings.c:  Cleaning up code wrong value used in aspect ratio. 
Date: Sat, 14 Jun 2014 13:37:08 +0200
Message-Id: <1402745829-12895-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wrong value used in same cases for the aspect ratio.
This is likely a cut and paste mistake.

This was partly found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  media: v4l2-core: v4l2-dv-timings.c:  Cleaning up code wrong value used in aspect ratio.

 drivers/media/v4l2-core/v4l2-dv-timings.c |    4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

-- 
1.7.10.4

