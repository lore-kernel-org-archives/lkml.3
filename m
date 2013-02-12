Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757896Ab3BLWFs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Feb 2013 17:05:48 -0500
Received: from mga03.intel.com ([143.182.124.21]:31756 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754307Ab3BLWEf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Feb 2013 17:04:35 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,652,1355126400"; 
   d="scan'208";a="256096887"
From: Andi Kleen <andi@firstfloor.org>
To: mingo@elte.hu
Cc: linux-kernel@vger.kernel.org, eranian@google.com
Subject: Basic perf PMU support for Haswell v6
Date: Tue, 12 Feb 2013 14:04:13 -0800
Message-Id: <1360706658-13468-1-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.7.7.6
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is based on v7 of the full Haswell PMU support, but 
ported to the latest perf/core and stripped down to the
bare bones

Only for very extremly basic usage.

Most interesting new features are not in this patchkit
(full version is git://git.kernel.org/pub/scm/linux/kernel/git/ak/linux-misc.git hsw/pmu5)

Contains support for:
- Basic Haswell PMU and PEBS support
- Late unmasking of the PMI
- Support for wide counters

v2: Addressed Stephane's feedback. See individual patches for details.
v3: now even more bite-sized. Qualifier constraints merged earlier.
v4: Rename some variables, add some comments and other minor changes.
Add some Reviewed/Tested-bys.
v5: Address some minor review feedback. Port to latest perf/core
v6: Add just some variable names, add comments, edit descriptions, some
more testing, rebased to latest perf/core

-Andi
