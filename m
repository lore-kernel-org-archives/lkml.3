Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756041AbaGBQ3a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:29:30 -0400
Received: from mga01.intel.com ([192.55.52.88]:61144 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753696AbaGBQ33 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:29:29 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,589,1400050800"; 
   d="scan'208";a="556492296"
Subject: [PATCH 0/4] [v3] x86 disabled features macros
To: bp@alien8.de
Cc: x86@kernel.org, hpa@zytor.com, qiaowei.ren@intel.com,
        linux-kernel@vger.kernel.org, Dave Hansen <dave@sr71.net>
From: Dave Hansen <dave@sr71.net>
Date: Wed, 02 Jul 2014 09:29:25 -0700
Message-Id: <20140702162925.B07A3AB9@viggo.jf.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Note: the fourth patch in the series would not hurt if it got
pulled in to a tree now, but it does not make any sense until we
get MPX merged.  We plan to roll it in to the MPX patch set.

Changes from v2:
 * also axe PAE macro
 * fix typo in comment
 * put K6_MTRR in the right DISABLED_MASK leaf

