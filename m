Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753216AbaCAQYQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Mar 2014 11:24:16 -0500
Received: from mga09.intel.com ([134.134.136.24]:3685 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752963AbaCAQYP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Mar 2014 11:24:15 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,568,1389772800"; 
   d="scan'208";a="492169946"
From: Andi Kleen <andi@firstfloor.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>, "H. Peter Anvin" <hpa@zytor.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: Re: perf_fuzzer compiled for x32 causes reboot
References: <alpine.DEB.2.10.1402241130080.20170@vincent-weaver-1.um.maine.edu>
	<20140225094352.73e0e28c@gandalf.local.home>
	<alpine.DEB.2.10.1402251032230.23234@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402261003390.18730@vincent-weaver-1.um.maine.edu>
	<alpine.DEB.2.10.1402271621000.2571@vincent-weaver-1.um.maine.edu>
	<20140227173150.4e5ed747@gandalf.local.home>
	<530FC1C6.5040209@zytor.com>
	<alpine.DEB.2.10.1402272032140.6271@vincent-weaver-1.um.maine.edu>
	<20140227215726.7018c861@gandalf.local.home>
	<alpine.DEB.2.10.1402280914550.6727@vincent-weaver-1.um.maine.edu>
	<20140228092341.12a40f7c@gandalf.local.home>
	<alpine.DEB.2.10.1402280957470.6727@vincent-weaver-1.um.maine.edu>
	<40f095f7-605f-4885-951f-31da7d2d637a@email.android.com>
	<alpine.DEB.2.10.1402281616280.7362@vincent-weaver-1.um.maine.edu>
	<20140228163039.6eb6a8d6@gandalf.local.home>
	<alpine.DEB.2.10.1402281829330.7966@vincent-weaver-1.um.maine.edu>
	<20140228223651.485042cc@gandalf.local.home>
Date: Sat, 01 Mar 2014 08:24:14 -0800
In-Reply-To: <20140228223651.485042cc@gandalf.local.home> (Steven Rostedt's
	message of "Fri, 28 Feb 2014 22:36:51 -0500")
Message-ID: <87bnxp6g5t.fsf@tassilo.jf.intel.com>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.3 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Steven Rostedt <rostedt@goodmis.org> writes:
>
> BTW, is the perf_fuzzer code posted somewhere? It sounds like it can be
> really useful for us to do our own testing too.

I believe it's part of trinity.

http://codemonkey.org.uk/projects/trinity/

Perhaps it should have a "ftracer fuzzer" too?

-Andi
