Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaDFVZ2 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 6 Apr 2014 17:25:28 -0400
Received: from mail-yh0-f42.google.com ([209.85.213.42]:40568 "EHLO
	mail-yh0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750797AbaDFVZ0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 6 Apr 2014 17:25:26 -0400
Message-ID: <5341C643.4050700@gmail.com>
Date: Sun, 06 Apr 2014 16:25:23 -0500
From: Joel Pelaez Jorge <joelpelaez@gmail.com>
Organization: DarkSoft Foundation
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Silvan Jegen <s.jegen@gmail.com>
CC: devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: [PATCH 0/3] Staging: rtl8192e: Fix code issues
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In the kernel driver: rtl8192e, exists some problems related
to source check, using the tool sparse, but for fix it, is necessary
remove a bad declaration that keep off the patch.

Because it is resolved before apply the "main" patch.

Joel Pelaez Jorge (2):
  Staging: rtl8192e: Remove bad 'extern' declaration
  Staging: rtl8192e: Fix sparse warning

 drivers/staging/rtl8192e/rtl8192e/rtl_wx.c |    1 +
 drivers/staging/rtl8192e/rtl8192e/rtl_wx.h |    1 -
 2 files changed, 1 insertion(+), 1 deletion(-)

--
1.9.1

--
