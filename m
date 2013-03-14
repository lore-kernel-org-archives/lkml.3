Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753356Ab3CNWLz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:11:55 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:18873 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752982Ab3CNWLo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:11:44 -0400
From: Boris Ostrovsky <boris.ostrovsky@oracle.com>
To: bp@alien.de
Cc: chegger@amazon.de, xen-devel@lists.xen.org, linux-edac@vger.kernel.org,
        linux-kernel@vger.kernel.org, JBeulich@suse.com,
        stable@vger.kernel.org, boris.ostrovsky@oracle.com
Subject: [PATCH v2 0/2] AMD MCE fixes
Date: Thu, 14 Mar 2013 17:10:39 -0400
Message-Id: <1363295441-1859-1-git-send-email-boris.ostrovsky@oracle.com>
X-Mailer: git-send-email 1.8.1.2
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Boris,

Here is the updated patch for determining number of regiter banks on
AMD plus a patch removing shared_bank array, as you suggested.

Offline/online testing didn't show any issues.



Boris Ostrovsky (2):
  x86/mce: Replace shared_bank array with is_shared_bank() helper
  x86/mce: Use MCG_CAP MSR to find out number of banks on AMD

 arch/x86/kernel/cpu/mcheck/mce_amd.c | 38 ++++++++++++++++++++++--------------
 1 file changed, 23 insertions(+), 15 deletions(-)

-- 
1.8.1.2

