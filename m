Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752027AbaFORUE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 13:20:04 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:40642 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751783AbaFORUC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 13:20:02 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Larry Finger <Larry.Finger@lwfinger.net>,
        Florian Schilhabel <florian.c.schilhabel@googlemail.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Paul Gortmaker <paul.gortmaker@windriver.com>,
        Thomas Cort <linuxgeek@gmail.com>,
        Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8712: rtl871x_ioctl_linux.c:  Cleaning up useless if statement  
Date: Sun, 15 Jun 2014 19:20:57 +0200
Message-Id: <1402852858-1352-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The same code regardless of the outcome of the if statement. This may of
course be a miss and there should be a difference in the code.
And clean up another duplicate line of code.

This was partly found using a static code analysis program called cppcheck.

Rickard Strandqvist (1):
  staging: rtl8712: rtl871x_ioctl_linux.c:  Cleaning up useless if statement

 drivers/staging/rtl8712/rtl871x_ioctl_linux.c |    7 +------
 1 file changed, 1 insertion(+), 6 deletions(-)

-- 
1.7.10.4

