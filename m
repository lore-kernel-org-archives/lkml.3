Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933266AbaLBV0n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 16:26:43 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:58409
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932800AbaLBV0m (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 16:26:42 -0500
X-Greylist: delayed 452 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Dec 2014 16:26:42 EST
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/3] Drivers: hv: hv_balloon 
Date: Tue,  2 Dec 2014 14:28:51 -0800
Message-Id: <1417559331-13691-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bug fixes for the balloon driver.

K. Y. Srinivasan (3):
  Drivers: hv: hv_balloon: Make adjustments in computing the floor
  Drivers: hv: hv_balloon: Fix a locking bug in the balloon driver
  Drivers: hv: hv_balloon: Don't post pressure status from interrupt
    context

 drivers/hv/hv_balloon.c |   89 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 73 insertions(+), 16 deletions(-)

-- 
1.7.4.1

