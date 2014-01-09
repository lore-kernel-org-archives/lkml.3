Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755551AbaAIWq6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Jan 2014 17:46:58 -0500
Received: from mail-ea0-f178.google.com ([209.85.215.178]:60166 "EHLO
	mail-ea0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755177AbaAIWq4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Jan 2014 17:46:56 -0500
From: Rostislav Lisovy <lisovy@gmail.com>
To: Ian Abbott <abbotti@mev.co.uk>,
        Hartley Sweeten <hsweeten@visionengravers.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Cc: pisa@cmp.felk.cvut.cz, Rostislav Lisovy <lisovy@gmail.com>
Subject: [PATCH v3] comedi: Humusoft MF634 and MF624 DAQ cards driver
Date: Thu,  9 Jan 2014 23:46:45 +0100
Message-Id: <1389307606-6392-1-git-send-email-lisovy@gmail.com>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes since v2:
* Removed one unused constant
* Corrected commit message

Changes since v1:
* Implemented all the small and big remarks pointed out by
  Hartley Sweeten, Dan Carpenter and Ian Abbott

Rostislav Lisovy (1):
  comedi: Humusoft MF634 and MF624 DAQ cards driver

 drivers/staging/comedi/Kconfig          |   6 +
 drivers/staging/comedi/comedidev.h      |   1 +
 drivers/staging/comedi/drivers/Makefile |   1 +
 drivers/staging/comedi/drivers/mf6x4.c  | 354 ++++++++++++++++++++++++++++++++
 4 files changed, 362 insertions(+)
 create mode 100644 drivers/staging/comedi/drivers/mf6x4.c

-- 
1.8.3.2

