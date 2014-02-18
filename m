Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756031AbaBRO3x (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 09:29:53 -0500
Received: from mga02.intel.com ([134.134.136.20]:2070 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755981AbaBRO3r (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 09:29:47 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,502,1389772800"; 
   d="scan'208";a="457420252"
From: Andi Kleen <andi@firstfloor.org>
To: linux-kernel@vger.kernel.org
Cc: sam@ravnborg.org, x86@kernel.org, linux-kbuild@vger.kernel.org
Subject: Link Time Optimization patchkit v3
Date: Tue, 18 Feb 2014 15:28:38 +0100
Message-Id: <1392733738-8290-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.8.5.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

LTO allows the compiler to do global optimization over the whole kernel.

Updated version of the LTO patchkit, mainly for fixing Sam's review
comments.  I also rebased to 3.14-rc3 and added a fix for bloat-o-meter
with gcc 4.9

See the individual patches for a detailed description

Dependencies: asmlinkage patchkit (posted two weeks ago), kallsyms patchkit
(plus LTO capable toolchain, see documentation)

Full git tree is in
git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc lto-3.14

-Andi

