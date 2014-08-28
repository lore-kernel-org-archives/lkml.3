Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752474AbaH1XgM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:36:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:51525 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750773AbaH1XgL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:36:11 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,421,1406617200"; 
   d="scan'208";a="473631461"
From: "John L. Hammond" <john.hammond@intel.com>
To: <greg@kroah.com>, <andreas.dilger@intel.com>, <oleg.drokin@intel.com>
CC: <linux-kernel@vger.kernel.org>
Subject: [PATCH 00/11] staging/lustre flatten some headers
Date: Thu, 28 Aug 2014 18:35:08 -0500
Message-ID: <1409268919-16155-1-git-send-email-john.hammond@intel.com>
X-Mailer: git-send-email 1.7.9.5
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.1.200.108]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This series removes several headers from lustre/include/linux by
taking whatever was worthwhile from linux/lustre_barf.h and moving it
to lustre_barf.h or to wherever it's needed.

