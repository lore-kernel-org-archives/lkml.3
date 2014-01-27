Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754389AbaA0U2X (ORCPT <rfc822;w@1wt.eu>);
	Mon, 27 Jan 2014 15:28:23 -0500
Received: from mga01.intel.com ([192.55.52.88]:51743 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751843AbaA0U2V (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 27 Jan 2014 15:28:21 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,731,1384329600"; 
   d="scan'208";a="471628365"
From: Tomas Winkler <tomas.winkler@intel.com>
To: gregkh@linuxfoundation.org
Cc: arnd@arndb.de, linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Tomas Winkler <tomas.winkler@intel.com>
Subject: [char-misc 0/2] mei: memory leak fixes
Date: Mon, 27 Jan 2014 22:27:22 +0200
Message-Id: <1390854444-30650-1-git-send-email-tomas.winkler@intel.com>
X-Mailer: git-send-email 1.8.5.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A memory leak was detected in the mei driver,
here are two fixes that should address that. 

I suggest this goes to stable as well

Alexander Usyskin (2):
  mei: clear write cb from waiting list on reset
  mei: don't unset read cb ptr on reset

 drivers/misc/mei/client.c | 11 +++++++++--
 1 file changed, 9 insertions(+), 2 deletions(-)

-- 
1.8.5.3

