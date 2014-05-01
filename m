Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752198AbaEAVGF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 17:06:05 -0400
Received: from one.firstfloor.org ([193.170.194.197]:58362 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751728AbaEAVGE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 17:06:04 -0400
Date: Thu, 1 May 2014 23:06:01 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Josh Poimboeuf <jpoimboe@redhat.com>
Cc: Andi Kleen <andi@firstfloor.org>, Seth Jennings <sjenning@redhat.com>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@redhat.com>, Jiri Slaby <jslaby@suse.cz>,
        linux-kernel@vger.kernel.org
Subject: Re: [RFC PATCH 0/2] kpatch: dynamic kernel patching
Message-ID: <20140501210601.GG2382@two.firstfloor.org>
References: <cover.1398958771.git.jpoimboe@redhat.com>
 <87ppjxcjo2.fsf@tassilo.jf.intel.com>
 <20140501210154.GC3907@treble.redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140501210154.GC3907@treble.redhat.com>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> When bar returns, would it skip foo and go straight back to foo's
> caller?  If so, then it should be safe to patch foo after it jumps to
> bar.

foo is no problem, you see it in the backtrace.
But you don't see bar.

-Andi

-- 
ak@linux.intel.com -- Speaking for myself only.
