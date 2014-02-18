Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755884AbaBROZO (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:25:14 -0500
Received: from mga09.intel.com ([134.134.136.24]:38331 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755711AbaBROZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:25:11 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="457418378"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org
Subject: Single pass kallsyms v3
Date: Tue, 18 Feb 2014 15:24:24 +0100
Message-Id: <1392733470-8228-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Updated patchkit to enable single-pass kallsyms. This avoids
linking multiple times. Needed for the link time optimization
patchkit, but also useful on its own to get faster builds.

This version addresses Sam's review comments.

-Andi

