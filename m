Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752609AbaAMTWs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 14:22:48 -0500
Received: from mga11.intel.com ([192.55.52.93]:32913 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752221AbaAMTWq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 14:22:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,654,1384329600"; 
   d="scan'208";a="464459314"
Subject: [PATCH 00/12] [v2] Reorganize x86 Kconfig menu
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 13 Jan 2014 11:22:45 -0800
Message-Id: <20140113192245.3F682C7F@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Changes from v1:
 * put MTRR under "Processor Options"
 * fix circular dependency introduced in the paravirt shuffle
 * dump extended platforms down to the end of the menu

--

The x86 "Processor type and features" menu has really been
letting itself go over the years.  It needs to be put on a
diet as a new-year's resolution.

This takes us from about 80 lines of options down to about 20.
