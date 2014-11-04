Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaKDBrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:47:43 -0500
Received: from mail-pa0-f49.google.com ([209.85.220.49]:65151 "EHLO
	mail-pa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750894AbaKDBrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:47:41 -0500
From: varkabhadram@gmail.com
To: gregkh@linuxfoundation.org, linux-usb@vger.kernel.org
Cc: balbi@ti.com, stern@rowland.harvard.edu,
        sergei.shtylyov@cogentembedded.com, linux-kernel@vger.kernel.org,
        Varka Bhadram <varkab@cdac.in>
Subject: [PATCH usb v4 0/2] fixes on resource check
Date: Tue,  4 Nov 2014 07:17:09 +0530
Message-Id: <1415065631-6010-1-git-send-email-varkabhadram@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <N>
References: <N>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Varka Bhadram <varkab@cdac.in>

This series fixes for NULL pointer dereference on resource.

Series based on usb-next of [1]

changes:
	Up to v3, combined series for fixes and cleanups for resource
check. For v4 seperated as two series on for fixes another for cleanups.

[1]: https://git.kernel.org/cgit/linux/kernel/git/gregkh/usb.git

Varka Bhadram (2):
  host: uhci-platform: fix NULL pointer dereference on resource
  host: ehci-sead3: fix NULL pointer dereference on resource

 drivers/usb/host/ehci-sead3.c    |    5 ++---
 drivers/usb/host/uhci-platform.c |    6 +++---
 2 files changed, 5 insertions(+), 6 deletions(-)

-- 
1.7.9.5

