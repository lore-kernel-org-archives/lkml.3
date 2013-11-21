Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754013Ab3KUUAu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 15:00:50 -0500
Received: from mail-pb0-f52.google.com ([209.85.160.52]:56861 "EHLO
	mail-pb0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751225Ab3KUUAt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 15:00:49 -0500
From: Conrad Gomes <conrad.s.j.gomes@gmail.com>
To: abbotti@mev.co.uk, hsweeten@visionengravers.com,
        gregkh@linuxfoundation.org, joe@perches.com
Cc: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org,
        Conrad Gomes <conrad.s.j.gomes@gmail.com>
Subject: [PATCH V2 0/7] Staging: comedi: fix coding style issues in unioxx5.c
Date: Fri, 22 Nov 2013 01:27:51 +0530
Message-Id: <1385063878-10267-1-git-send-email-conrad.s.j.gomes@gmail.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series contains various fixes to coding style issues in unioxx5.c
found by checkpatch.pl and due to the usage of pr_err instead of the 
preferred dev_err type functions for device drivers.

Conrad Gomes (7):
  Staging: comedi: fix line over 80 character warning in unioxx5.c
  Staging: comedi: fix line over 80 character warning in unioxx5.c
  Staging: comedi: change printk to dev_err/dev_dbg in unioxx5.c
  Staging: comedi: change pr_err to dev_err in __unioxx5_analog_read
  Staging: comedi: change pr_err to dev_err in __unioxx5_digital_write
  Staging: comedi: change pr_err to dev_err in __unioxx5_analog_write
  Staging: comedi: remove MACRO pr_fmt in unioxx5.c

 drivers/staging/comedi/drivers/unioxx5.c |   50 ++++++++++++++++++------------
 1 file changed, 31 insertions(+), 19 deletions(-)

-- 
1.7.9.5

