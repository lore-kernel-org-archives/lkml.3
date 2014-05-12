Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753250AbaELJUv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 May 2014 05:20:51 -0400
Received: from mga09.intel.com ([134.134.136.24]:57347 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752579AbaELJUt (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 May 2014 05:20:49 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,1033,1389772800"; 
   d="scan'208";a="510161836"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 0/3] mei: me hw reset fixes
Date: Mon, 12 May 2014 12:19:38 +0300
Message-Id: <1399886381-16040-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.9.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Tomas Winkler (3):
  mei: me: fix hw ready reset flow
  mei: me: drop harmful wait optimization
  mei: me: read H_CSR after asserting reset

 drivers/misc/mei/hw-me.c | 25 +++++++++++++++++++------
 1 file changed, 19 insertions(+), 6 deletions(-)

-- 
1.9.0

