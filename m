Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759512Ab3CZLgz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 07:36:55 -0400
Received: from mout.web.de ([212.227.17.12]:53528 "EHLO mout.web.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1758981Ab3CZLgy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 07:36:54 -0400
From: Danny Baumann <dannybaumann@web.de>
To: Matthew Garrett <mjg59@srcf.ucam.org>
Cc: platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org,
        Danny Baumann <dannybaumann@web.de>
Subject: [PATCH 0/1] dell-wmi: Add support for keys present on Inspiron 15R SE.
Date: Tue, 26 Mar 2013 12:36:33 +0100
Message-Id: <1364297794-3931-1-git-send-email-dannybaumann@web.de>
X-Mailer: git-send-email 1.8.1.4
X-Provags-ID: V02:K0:GehFhX6tgVyubnOxqnmcHpCOyCYvaLlVRgulnA2xGd0
 bzuZW9aTu0yYcGj9+Y6f7X49SIxRNclqN0b3Kz1BwLYgBwEW5c
 KrUC+vJ2DYHWsRIsr6wUhoPN9tl2geKtiz5U+nRyl+9+aU0IUE
 ettItAOMfbopdSeA1d6rixmf6eaIMc+WQvVM1apVgqSd0VNLAI
 CRHa9VZr8sgSKzjXray9g==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for some keys of the newer Inspiron models not
yet supported (the two buttons in the upper right corner in [1]). I'm not
yet entirely sure what the best way to handle the audio one (in the middle)
is (whether it's best to handle the key-down or the key-up event, and what
scancode to use), I would appreciate input on that.

Regards,

Danny

[1] http://www.tomshw.it/files/2012/08/collezioni/1752/32067_b.jpg

Danny Baumann (1):
  dell-wmi: Add support for keys present on Inspiron 15R SE.

 drivers/platform/x86/dell-wmi.c | 9 +++++++++
 1 file changed, 9 insertions(+)

-- 
1.8.1.4

