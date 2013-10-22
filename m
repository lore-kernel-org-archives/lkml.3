Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754630Ab3JVQMe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Oct 2013 12:12:34 -0400
Received: from mga03.intel.com ([143.182.124.21]:5678 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753413Ab3JVQMc (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Oct 2013 12:12:32 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,535,1378882800"; 
   d="scan'208";a="311163022"
From: Andi Kleen <andi@firstfloor.org>
To: akpm@linux-foundation.org
Cc: linux-kernel@vger.kernel.org
Subject: Various asmlinkage fixes for LTO
Date: Tue, 22 Oct 2013 09:12:15 -0700
Message-Id: <1382458346-24811-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTO (Link Time Optimization) requires all C symbols used from
assembler to be marked visible. This patchkit marks various
functions over the tree asmlinkage or __visible, when they
are used by assembler.

-Andi
