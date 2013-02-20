Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935350Ab3BTO1h (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 09:27:37 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:3445 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758539Ab3BTO1g (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 09:27:36 -0500
X-Server-Uuid: 06151B78-6688-425E-9DE2-57CB27892261
From: "Shankar Brahadeeswaran" <shankoo77@gmail.com>
To: "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        linux-kernel@vger.kernel.org
cc: devel@driverdev.osuosl.org, "Cruz Julian Bishop" <cruzjbishop@gmail.com>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Hugh Dickins" <hughd@google.com>,
        "Konstantin Khlebnikov" <khlebnikov@openvz.org>,
        "Shankar Brahadeeswaran" <shankoo77@gmail.com>
Subject: [PATCH V2 1/1] staging: android: ashmem: get_name,set_name not
 to hold ashmem_mutex
Date: Wed, 20 Feb 2013 19:57:07 +0530
Message-ID: <1361370428-30632-1-git-send-email-shankoo77@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
References: <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
MIME-Version: 1.0
X-WSS-ID: 7D3A035F23C965838-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,
Fixed the review comments and re-tested again.
Hope the patch is clean atleast this time.

Warm regards,
Shankar

Shankar Brahadeeswaran (1):
  staging: android: ashmem: get_name,set_name not to hold     
    ashmem_mutex

 drivers/staging/android/ashmem.c |   56 ++++++++++++++++++++++++-------------
 1 files changed, 36 insertions(+), 20 deletions(-)

-- 
1.7.6


