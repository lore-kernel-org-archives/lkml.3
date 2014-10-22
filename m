Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932715AbaJVKoF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 06:44:05 -0400
Received: from mga02.intel.com ([134.134.136.20]:43425 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932499AbaJVKoD (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 06:44:03 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,768,1406617200"; 
   d="scan'208";a="593668786"
From: Jani Nikula <jani.nikula@intel.com>
To: Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        Kees Cook <keescook@chromium.org>
Cc: "LKML" <linux-kernel@vger.kernel.org>
Subject: regression: checkpatch.pl fails when called via symlink
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Notmuch/0.18.1+133~g83c61fa (http://notmuchmail.org) Emacs/24.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 22 Oct 2014 13:43:45 +0300
Message-ID: <874muwv0ym.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Since commit 66b47b4a9dad00e45c049d79966de9a3a1f4d337
Author: Kees Cook <keescook@chromium.org>
Date:   Mon Oct 13 15:51:57 2014 -0700

    checkpatch: look for common misspellings

checkpatch.pl dies with

checkpatch.pl: Can't open /path/to/spelling.txt for reading: No such file or directory

if it's called through a symlink in /path/to/checkpatch.pl pointing at
the actual script.

Please fail graciously, and just ignore spelling if you can't find
spelling.txt. Or better yet, follow the links if you can.


Thanks,
Jani.


-- 
Jani Nikula, Intel Open Source Technology Center
