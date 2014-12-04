Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754448AbaLDRuS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Dec 2014 12:50:18 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:33386
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754308AbaLDRuR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Dec 2014 12:50:17 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        jasowang@redhat.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 0/3] Drivers: hv: hv_balloon 
Date: Thu,  4 Dec 2014 11:00:03 -0800
Message-Id: <1417719603-7751-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some bug fixes for the balloon driver. In this version,
based on Dan Carpenter's comment, I have added some additional
information to the change log.

K. Y. Srinivasan (3):
  Drivers: hv: hv_balloon: Make adjustments in computing the floor
  Drivers: hv: hv_balloon: Fix a locking bug in the balloon driver
  Drivers: hv: hv_balloon: Don't post pressure status from interrupt
    context

 drivers/hv/hv_balloon.c |   89 ++++++++++++++++++++++++++++++++++++++--------
 1 files changed, 73 insertions(+), 16 deletions(-)

-- 
1.7.4.1

