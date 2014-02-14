Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752735AbaBNVRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Feb 2014 16:17:55 -0500
Received: from mga02.intel.com ([134.134.136.20]:10900 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751838AbaBNVRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Feb 2014 16:17:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,847,1384329600"; 
   d="scan'208";a="483677303"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: x86@kernel.org, linux-kbuild@vger.kernel.org, mmarek@suse.cz
Subject: Updated single-pass kallsyms patchkit for LTO
Date: Fri, 14 Feb 2014 22:17:03 +0100
Message-Id: <1392412629-25666-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Mostly fix the padding code build error Markus found.

The single pass code generally improves build performance,
even without LTO.

