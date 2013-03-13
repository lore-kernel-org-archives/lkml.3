Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934110Ab3CMSYs (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Mar 2013 14:24:48 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48505 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933133Ab3CMSYq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Mar 2013 14:24:46 -0400
From: manoj.iyer@canonical.com
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Timo Aaltonen <tjaalton@ubuntu.com>, linux-usb@vger.kernel.org,
        manoj.iyer@canonical.com
Subject: [PATCH 0/1] USB: Added quirk to recognize GE0301 3G modem as an interface.
Date: Wed, 13 Mar 2013 13:24:42 -0500
Message-Id: <1363199082-7081-1-git-send-email-manoj.iyer@canonical.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Manoj Iyer <manoj.iyer@canonical.com>

This patch enables GE0301 3G modem as an interface, the patch has been 
part of the Ubuntu kernel for a while but I forgot to upstream. 
Test details can be found in the bug http://bugs.launchpad.net/bugs/348861

Please consider this patch for upstream. 

Manoj Iyer (1):
  USB: Added quirk to recognize GE0301 3G modem as an interface.

 drivers/usb/storage/unusual_devs.h |    7 +++++++
 1 file changed, 7 insertions(+)

-- 
1.7.9.5

