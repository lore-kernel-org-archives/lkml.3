Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753967AbaLEXbW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 18:31:22 -0500
Received: from p3plsmtps2ded01.prod.phx3.secureserver.net ([208.109.80.58]:45099
	"EHLO p3plsmtps2ded01.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752738AbaLEXbS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 18:31:18 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, olaf@aepfle.de, apw@canonical.com,
        linux-mm@kvack.org, isimatu.yasuaki@jp.fujitsu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 0/2] Drivers: hv: hv_balloon: Fix a deadlock in the hot-add path. 
Date: Fri,  5 Dec 2014 16:41:11 -0800
Message-Id: <1417826471-21131-1-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fix a deadlock in the hot-add path in the Hyper-V balloon driver.

K. Y. Srinivasan (2):
  Drivers: base: core: Export functions to lock/unlock device hotplug
    lock
  Drivers: hv: balloon: Fix the deadlock issue in the memory hot-add
    code

 drivers/base/core.c     |    2 ++
 drivers/hv/hv_balloon.c |    4 ++++
 2 files changed, 6 insertions(+), 0 deletions(-)

-- 
1.7.4.1

