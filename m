Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754532AbaKEKtj (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 05:49:39 -0500
Received: from mail.skyhub.de ([78.46.96.112]:58923 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751477AbaKEKth (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 05:49:37 -0500
Date: Wed, 5 Nov 2014 11:49:35 +0100
From: Borislav Petkov <bp@alien8.de>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: linux-kernel@vger.kernel.org, Ingo Molnar <mingo@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        Jiri Kosina <jkosina@suse.cz>, Josh Poimboeuf <jpoimboe@redhat.com>,
        Vojtech Pavlik <vojtech@suse.cz>, Seth Jennings <sjenning@redhat.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: Re: [for-next][PATCH 4/4] ftrace: Add more information to
 ftrace_bug() output
Message-ID: <20141105104935.GD5245@pd.tnic>
References: <20141027182702.778680710@goodmis.org>
 <20141027182948.733905051@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20141027182948.733905051@goodmis.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 27, 2014 at 02:27:06PM -0400, Steven Rostedt wrote:
> From: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
> 
> With the introduction of the dynamic trampolines, it is useful that if
> things go wrong that ftrace_bug() produces more information about what
> the current state is. This can help debug issues that may arise.
> 
> Ftrace has lots of checks to make sure that the state of the system it
> touchs is exactly what it expects it to be. When it detects an abnormality
> it calls ftrace_bug() and disables itself to prevent any further damage.
> It is crucial that ftrace_bug() produces sufficient information that
> can be used to debug the situation.
> 
> Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Acked-by: Borislav Petkov <bp@suse.de>

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
