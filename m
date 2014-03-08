Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753021AbaCHBAr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 20:00:47 -0500
Received: from smtp.outflux.net ([198.145.64.163]:49943 "EHLO smtp.outflux.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752302AbaCHBAn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 20:00:43 -0500
From: Kees Cook <keescook@chromium.org>
To: Rusty Russell <rusty@rustcorp.com.au>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andrew Honig <ahonig@google.com>, Michal Marek <mmarek@suse.cz>,
        "x86@kernel.org" <x86@kernel.org>, Tejun Heo <tj@kernel.org>,
        Tony Luck <tony.luck@intel.com>, Fenghua Yu <fenghua.yu@intel.com>,
        linux-ia64@vger.kernel.org, keescook@chromium.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH v2 0/2] kallsyms: handle special absolute symbols
Date: Fri,  7 Mar 2014 17:00:23 -0800
Message-Id: <1394240425-11647-1-git-send-email-keescook@chromium.org>
X-Mailer: git-send-email 1.7.9.5
X-HELO: www.outflux.net
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handles 0-based per_cpu variables as being absolute so they are
not relocated under kASLR on x86_64.

-Kees

