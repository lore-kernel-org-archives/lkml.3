Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759207Ab3BYSo1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Feb 2013 13:44:27 -0500
Received: from cam-admin0.cambridge.arm.com ([217.140.96.50]:47323 "EHLO
	cam-admin0.cambridge.arm.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754529Ab3BYSo0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Feb 2013 13:44:26 -0500
From: Serban Constantinescu <serban.constantinescu@arm.com>
To: linux-kernel@vger.kernel.org, gregkh@linuxfoundation.org,
        kernel-team@android.com, arve@android.com, john.stultz@linaro.org,
        Dave.Butcher@arm.com
Cc: Serban Constantinescu <serban.constantinescu@arm.com>
Subject: [PATCH] staging: android: ashmem: add 32bit compat support
Date: Mon, 25 Feb 2013 18:44:35 +0000
Message-Id: <1361817876-24747-1-git-send-email-serban.constantinescu@arm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <staging: android: ashmem: add 32bit compat support>
References: <staging: android: ashmem: add 32bit compat support>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi all,

As disussed with the Android kernel team I am resubmitting this patch
without any modifications to the structure exchanged between kernel and
userspace.

The patch has been tested on 32(VExpress 4xA9) and 64bit platforms(RTSMv8)
running 32bit Android userspace and 64bit Linux + ashmem unit tests.

Thanks for your help,
Serban Constantinescu
PDSW Engineer ARM Ltd.

Serban Constantinescu (1):
  staging: android: ashmem: Add support for 32bit ashmem calls in a
    64bit kernel

 drivers/staging/android/ashmem.c |   21 ++++++++++++++++++++-
 drivers/staging/android/ashmem.h |    6 ++++++
 2 files changed, 26 insertions(+), 1 deletion(-)

-- 
1.7.9.5

