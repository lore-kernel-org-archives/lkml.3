Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752754AbaHSLaL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Aug 2014 07:30:11 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:39660 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751862AbaHSLaG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Aug 2014 07:30:06 -0400
From: Honggang Li <enjoymindful@gmail.com>
To: benjamin.romer@unisys.com, david.kershner@unisys.com,
        gregkh@linuxfoundation.org, erik.arfvidson@unisys.com,
        sparmaintainer@unisys.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Honggang Li <enjoymindful@gmail.com>
Subject: [linux-next PATCH] print u64 with %llu
Date: Tue, 19 Aug 2014 19:29:42 +0800
Message-Id: <1408447783-22287-2-git-send-email-enjoymindful@gmail.com>
X-Mailer: git-send-email 1.8.3.1
In-Reply-To: <1408447783-22287-1-git-send-email-enjoymindful@gmail.com>
References: <1408447783-22287-1-git-send-email-enjoymindful@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are printk format issue and coding style issue for the lines
changed by this patch. This patch only fix the format issue. Please
take those coding style errors as false positives for this patch.

Honggang Li (1):
  staging: unisys/virthba/virthba.c print u64 with %llu

 drivers/staging/unisys/virthba/virthba.c | 8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

-- 
1.8.3.1

