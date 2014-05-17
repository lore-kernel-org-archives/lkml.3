Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932396AbaEQKkq (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 May 2014 06:40:46 -0400
Received: from mout.gmx.net ([212.227.15.15]:49745 "EHLO mout.gmx.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932142AbaEQKkp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 May 2014 06:40:45 -0400
From: Christian Engelmayer <cengelma@gmx.at>
To: devel@driverdev.osuosl.org
Cc: gregkh@linuxfoundation.org, Larry.Finger@lwfinger.net,
        navin.patidar@gmail.com, Jes.Sorensen@redhat.com,
        linux-kernel@vger.kernel.org, Christian Engelmayer <cengelma@gmx.at>
Subject: [PATCH 0/2] staging: rtl8188eu: fix Coverity defects in rtw_drv_init() 
Date: Sat, 17 May 2014 12:38:56 +0200
Message-Id: <1400323138-32243-1-git-send-email-cengelma@gmx.at>
X-Mailer: git-send-email 1.9.1
X-Provags-ID: V03:K0:DpQN8OYPKyZEisJOlBFv6PxtKAltgZoqw4PKZ+4q6Le+jAZSpMU
 SeksJiMzQnEZXeoifk4bqT/IpR9V7qEDNlGkojNcNVUnQ00BlbZ+qN4bTXK4pOVIwRFEYwc
 AIss9wyUo1PNUXTQe5aHs7kwTL1caLIzrBPvOnv/rokkXxcfUDw1m98vwhib6NV2PabnUrg
 6GV8acAkbG/3Mts5T4tcg==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This addresses two issues currently reported by static analysis for function
rtw_drv_init() in drivers/staging/rtl8188eu/os_dep/usb_intf.c.

   CID 1077553 - Logically dead code
   CID 1077832 - Uninitialized scalar variable

Compile tested only. Applies against branch staging-next of tree
git.kernel.org/pub/scm/linux/kernel/git/gregkh/staging.git

Christian Engelmayer (2):
  staging: rtl8188eu: fix usage of uninit scalar in rtw_drv_init()
  staging: rtl8188eu: remove dead code in rtw_drv_init()

 drivers/staging/rtl8188eu/os_dep/usb_intf.c | 4 +---
 1 file changed, 1 insertion(+), 3 deletions(-)

-- 
1.9.1

