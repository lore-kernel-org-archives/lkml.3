Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934133Ab3BTSL6 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Feb 2013 13:11:58 -0500
Received: from mms1.broadcom.com ([216.31.210.17]:2034 "EHLO mms1.broadcom.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1759114Ab3BTSL5 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Feb 2013 13:11:57 -0500
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
Subject: [PATCH V3 1/1] staging: android: ashmem: get_name,set_name not
 to
Date: Wed, 20 Feb 2013 23:41:25 +0530
Message-ID: <1361383886-14805-1-git-send-email-shankoo77@gmail.com>
X-Mailer: git-send-email 1.7.6
In-Reply-To: <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
References: <1361363039-11984-2-git-send-email-shankoo77@gmail.com>
MIME-Version: 1.0
X-WSS-ID: 7D3BCEE223C1096206-01-01
Content-Type: text/plain
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dan,

Oh, now I got what you say. Thanks for your patience. 
I have done the necessary modifications.
Re-submitting the patch here

Shankar Brahadeeswaran (1):
  staging: android: ashmem: get_name,set_name      not to hold
    ashmem_mutex

 drivers/staging/android/ashmem.c |   45 +++++++++++++++++++++++++++-----------
 1 files changed, 32 insertions(+), 13 deletions(-)

-- 
1.7.6


