Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932126Ab3L3Sku (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 13:40:50 -0500
Received: from mga01.intel.com ([192.55.52.88]:13102 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932069Ab3L3Sks (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 13:40:48 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,575,1384329600"; 
   d="scan'208";a="457777366"
Subject: [PATCH 00/12] Reorganize x86 Kconfig menu
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Mon, 30 Dec 2013 10:40:46 -0800
Message-Id: <20131230184046.F5E42919@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The x86 "Processor type and features" menu has really been
letting itself go over the years.  It needs to be put on a
diet as a new-year's resolution.


