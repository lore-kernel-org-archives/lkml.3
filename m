Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751454AbaFOPNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 15 Jun 2014 11:13:12 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:43969 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751147AbaFOPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 15 Jun 2014 11:13:10 -0400
From: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>
Cc: Rickard Strandqvist <rickard_strandqvist@spectrumdigital.se>,
        Ana Rey <anarey@gmail.com>, Andrea Merello <andrea.merello@gmail.com>,
        Teodora Baluta <teobaluta@gmail.com>, Chi Pham <fempsci@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>,
        Xenia Ragiadakou <burzalodowa@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] staging: rtl8192u: r8192U_core.c:  Cleaning up unclear and confusing code  
Date: Sun, 15 Jun 2014 17:14:05 +0200
Message-Id: <1402845246-28125-1-git-send-email-rickard_strandqvist@spectrumdigital.se>
X-Mailer: git-send-email 1.7.10.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Removes confusing and unclear code. 
Using memcpy to set a pointer, what is the point?
The use of &= instead of & fills no benefit in this case.
None of these is a direct error, but I think you should replace the confusing code.

Rickard Strandqvist (1):
  staging: rtl8192u: r8192U_core.c:  Cleaning up unclear and confusing code

 drivers/staging/rtl8192u/r8192U_core.c |    5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

-- 
1.7.10.4

