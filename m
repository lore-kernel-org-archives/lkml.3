Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752731AbaFGDCe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 23:02:34 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:57780 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752553AbaFGDCd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 23:02:33 -0400
From: Thomas Wood <tommyandrena@gmail.com>
To: dan.carpenter@oracle.com
Cc: marek.belisko@gmail.com, devel@driverdev.osuosl.org,
        gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        Thomas Wood <tommyandrena@gmail.com>
Subject: [PATCH v2 0/5] staging: ft1000: ft1000-usb: ft1000_debug.c: Fix style errors and warnings.
Date: Fri,  6 Jun 2014 20:02:13 -0700
Message-Id: <1402110138-13713-1-git-send-email-tommyandrena@gmail.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <20140602103056.GY15585@mwanda>
References: <20140602103056.GY15585@mwanda>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v1:
 * Made single patch into a patch set.
 * Added better commit messages.

Is this better, or do I still have to split up my first patch?

>8------------------------------------------------------8<

Remove all style errors from ft1000_debug.c and some warnings.

Thomas Wood (5):
  staging: ft1000: ft1000-usb: ft1000_debug.c: Replace spaces with tabs.
  staging: ft1000: ft1000-usb: ft1000_debug.c: Add required spaces.
  staging: ft1000: ft1000-usb: ft1000_debug.c: Remove unnecessary
    whitespace.
  staging: ft1000: ft1000-usb: ft1000_debug.c: Remove unnecessary
    braces.
  staging: ft1000: ft1000-usb: ft1000_debug.c: Misc. fixes.

 drivers/staging/ft1000/ft1000-usb/ft1000_debug.c | 968 +++++++++++------------
 1 file changed, 480 insertions(+), 488 deletions(-)

-- 
1.9.1

