Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753130AbaHIAgY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 20:36:24 -0400
Received: from qmta07.emeryville.ca.mail.comcast.net ([76.96.30.64]:47500 "EHLO
	qmta07.emeryville.ca.mail.comcast.net" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751038AbaHIAgX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 20:36:23 -0400
From: Shuah Khan <shuah.kh@samsung.com>
To: m.chehab@samsung.com, dheitmueller@kernellabs.com
Cc: Shuah Khan <shuah.kh@samsung.com>, linux-media@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] au0828: au0828_rc_*() defines cleanup 
Date: Fri,  8 Aug 2014 18:36:17 -0600
Message-Id: <cover.1407544065.git.shuah.kh@samsung.com>
X-Mailer: git-send-email 1.9.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Define au0828_rc_*() stubs to avoid compile errors when
VIDEO_AU0828_RC is disabled and avoid the need to enclose
au0828_rc_*() in ifdef CONFIG_VIDEO_AU0828_RC in .c files.

This patch series adds stubs and fixes places where ifdef
is used.

Shuah Khan (2):
  au0828: add au0828_rc_*() stubs for VIDEO_AU0828_RC disabled case
  au0828: remove CONFIG_VIDEO_AU0828_RC scope around au0828_rc_*()

 drivers/media/usb/au0828/au0828-core.c |    4 ----
 drivers/media/usb/au0828/au0828.h      |   15 +++++++++++----
 2 files changed, 11 insertions(+), 8 deletions(-)

-- 
1.7.10.4

