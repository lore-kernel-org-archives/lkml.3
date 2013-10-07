Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752444Ab3JGVlI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 7 Oct 2013 17:41:08 -0400
Received: from mga14.intel.com ([143.182.124.37]:56118 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751995Ab3JGVkz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 7 Oct 2013 17:40:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,1051,1371106800"; 
   d="scan'208";a="304411379"
From: Andi Kleen <andi@firstfloor.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: torvalds@linux-foundation.org, gregkh@linux-foundation.org,
        Andy Whitcroft <apw@canonical.com>, Joe Perches <joe@perches.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH] checkpatch: Make the 80-character limit a --strict check only
References: <20131007191835.GA28737@jtriplet-mobl1>
Date: Mon, 07 Oct 2013 14:40:53 -0700
In-Reply-To: <20131007191835.GA28737@jtriplet-mobl1> (Josh Triplett's message
	of "Mon, 7 Oct 2013 12:18:43 -0700")
Message-ID: <87txgszrmi.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Josh Triplett <josh@joshtriplett.org> writes:

> The 80-character limit is not a hard-and-fast rule, nor should it be
> applied blindly by people running checkpatch and fixing its warnings.
> Sometimes it's better to violate the 80-character "limit" in the name of
> readability, and when it isn't, it's often better to refactor into a
> function or otherwise restructure the code rather than just finding
> increasingly awkward places to break lines.

Yes please!

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only
