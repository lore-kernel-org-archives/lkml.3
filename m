Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935319Ab3BTMYT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 07:24:19 -0500
Received: from mms3.broadcom.com ([216.31.210.19]:1238 "EHLO mms3.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S935006Ab3BTMYS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 07:24:18 -0500
X-Server-Uuid: B86B6450-0931-4310-942E-F00ED04CA7AF
From: "Shankar Brahadeeswaran" <shankoo77@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
cc: devel@driverdev.osuosl.org, "Cruz Julian Bishop" <cruzjbishop@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Hugh Dickins" <hughd@google.com>,
        "Konstantin Khlebnikov" <khlebnikov@openvz.org>,
        "Shankar Brahadeeswaran" <shankoo77@gmail.com>
Subject: [PATCH 1/1] staging: android: ashmem: get_name,set_name not to
 hold ashmem_mutex
Date: Wed, 20 Feb 2013 17:53:58 +0530
Message-ID: <1361363039-11984-1-git-send-email-shankoo77@gmail.com>
X-Mailer: git-send-email 1.7.6
MIME-Version: 1.0
X-WSS-ID: 7D3A60983P4275333-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Greg,
This patch is to fix a dead lock scenario that is created in ashmem driver.
The inital patch for review was posted and I got some comments from Dan
Carpeneter.I have incorporated the changes and re-tested the
same. Submitting the final patch for your pursual.

Warm Regards,
Shankar

Shankar Brahadeeswaran (1):
  staging: android: ashmem: get_name,set_name not to hold      
    ashmem_mutex

 drivers/staging/android/ashmem.c |   44 ++++++++++++++++++++++++++++---------
 1 files changed, 33 insertions(+), 11 deletions(-)

-- 
1.7.6


