Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932547AbaAaRYp (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 Jan 2014 12:24:45 -0500
Received: from mga09.intel.com ([134.134.136.24]:41057 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932236AbaAaRYo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 Jan 2014 12:24:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.95,759,1384329600"; 
   d="scan'208";a="475907857"
Subject: [PATCH 0/3] General Kconfig reorganization
To: linux-kernel@vger.kernel.org
Cc: torvalds@linux-foundation.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Fri, 31 Jan 2014 09:24:43 -0800
Message-Id: <20140131172443.2EDC06E7@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changes from last version:
 * Change one sentence in the existing SECCOMP description to be
   the text that Ingo wants.

This continues in a series of patches to clean up the
configuration menus.  I believe they've become really hard to
navigate and there are some simple things we can do to make
things easier to find.

