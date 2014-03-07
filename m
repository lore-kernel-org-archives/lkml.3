Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752682AbaCGAc1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Mar 2014 19:32:27 -0500
Received: from smtp.outflux.net ([198.145.64.163]:51090 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751087AbaCGAcY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Mar 2014 19:32:24 -0500
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 0/2] kallsyms: handle special absolute symbols
Date: Thu,  6 Mar 2014 16:32:02 -0800
Message-Id: <1394152324-26304-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is an attempt at a more correct solution to the patch sent
earlier "kallsyms: fix absolute addresses for kASLR".

The main problem is that the entire per_cpu area needs to be treated 
as absolute by kallsyms. This series adds the logic to recognize the
per_cpu memory range and treat it as absolute in the kallsyms tool.

-Kees
