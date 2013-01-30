Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754042Ab3A3JNq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:13:46 -0500
Received: from mga01.intel.com ([192.55.52.88]:59676 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753183Ab3A3JNo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:13:44 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,566,1355126400"; 
   d="scan'208";a="280260111"
From: Jani Nikula <jani.nikula@intel.com>
To: Florian Mickler <florian@mickler.org>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        Daniel Vetter <daniel.vetter@ffwll.ch>
Subject: A patch referencing this bug report has been merged...
Organization: Intel Finland Oy - BIC 0357606-4 - Westendinkatu 7, 02160 Espoo
User-Agent: Notmuch/0.15.1+22~g943ed44 (http://notmuchmail.org) Emacs/23.3.1 (x86_64-pc-linux-gnu)
Date: Wed, 30 Jan 2013 11:14:01 +0200
Message-ID: <87zjzrdodi.fsf@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Hi Florian, all -

First, thanks for your work on adding the bugzilla comments when patches
referencing bugs get merged. I find it useful.

Recently however there was a comment about a commit referencing a commit
referencing the bug report. Turns out the comment was missing one level
of indirection, it was really about a commit referencing a commit
referencing a commit referencing the bug [1].

Do we really need go that far, or is that a bug in your scripts? I think
three levels of indirection is more noise than signal; two might be
still be okay. What do others think?

BR,
Jani.


[1] https://bugs.freedesktop.org/show_bug.cgi?id=52424#c56
