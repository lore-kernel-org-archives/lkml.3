Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933677AbaLLSjs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 13:39:48 -0500
Received: from mga02.intel.com ([134.134.136.20]:52750 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932185AbaLLSjr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 13:39:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,565,1413270000"; 
   d="scan'208";a="653006155"
Subject: [PATCH 0/2] x86, mpx: Updates for 3.19
To: linux-kernel@vger.kernel.org
Cc: tglx@linutronix.de, x86@kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 12 Dec 2014 10:38:34 -0800
Message-Id: <20141212183834.1F8D01E5@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's been a discussion on LKML about the Kconfig option for
MPX.  I've added an actual Kconfig prompt for the feature and
some nice help text.

I'm also sending a very minor update to the documentation.

 Documentation/x86/intel_mpx.txt |   18 ++++++++++++++----
 arch/x86/Kconfig                |   30 ++++++++++++++++++++++++++----
 2 files changed, 40 insertions(+), 8 deletions(-)

