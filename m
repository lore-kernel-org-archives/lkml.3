Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932068AbaKRSXr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 13:23:47 -0500
Received: from mga11.intel.com ([192.55.52.93]:6790 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753563AbaKRSXq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 13:23:46 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,411,1413270000"; 
   d="scan'208";a="624383339"
Subject: [PATCH 0/3] x86: MPX fixes for tip
To: tglx@linutronix.de
Cc: x86@kernel.org, linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Tue, 18 Nov 2014 10:23:42 -0800
Message-Id: <20141118182342.64D1B3A5@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes up an issue turned up by smatch as well as
some build issues on non-x86 architectures with the
new hooks we added for MPX.

