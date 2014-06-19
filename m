Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456AbaFSHYN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 03:24:13 -0400
Received: from mail-la0-f44.google.com ([209.85.215.44]:63651 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755782AbaFSHYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 03:24:12 -0400
From: Andrey Skvortsov <andrej.skvortzov@gmail.com>
X-Google-Original-From: Andrey Skvortsov <Andrej.Skvortzov@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: devel@driverdev.osuosl.org, andreas.dilger@intel.com,
        sachin.kamat@linaro.org, bergwolf@gmail.com,
        linux-kernel@vger.kernel.org
Subject: [PATCHv2 0/3] staging: lustre: obdclass: fixing coding style issues
Date: Thu, 19 Jun 2014 11:24:09 +0400
Message-Id: <1403162653-17845-1-git-send-email-Andrej.Skvortzov@gmail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20140618223533.GA5096@kroah.com>
References: <20140618223533.GA5096@kroah.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since PATCHv1:

I refreshed patch against the staging-next branch of the staging.git tree
and added some other coding style fixes as separate patches.


Andrey Skvortsov (3):
  staging: lustre: obdclass: linux-sysctl.c: fix pointer coding style
    issue
  staging: lustre: obdclass: linux-sysctl.c: fix checkpatch warnings
    about included headers
  staging: lustre: obdclass: linux-sysctl.c: fix unnecessary spaces
    coding style issue

 .../lustre/lustre/obdclass/linux/linux-sysctl.c    |   20 ++++++++++----------
 1 file changed, 10 insertions(+), 10 deletions(-)

-- 
1.7.10.4

