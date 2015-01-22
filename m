Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754139AbbAVRLL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Jan 2015 12:11:11 -0500
Received: from mail-we0-f172.google.com ([74.125.82.172]:43742 "EHLO
	mail-we0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753322AbbAVRLG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Jan 2015 12:11:06 -0500
Date: Thu, 22 Jan 2015 17:11:02 +0000
From: Matt Fleming <matt@codeblueprint.co.uk>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Jiri Olsa <jolsa@kernel.org>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>,
        Andi Kleen <andi@firstfloor.org>, Vince Weaver <vince@deater.net>,
        Vikas Shivappa <vikas.shivappa@linux.intel.com>,
        Kanaka Juvva <kanaka.d.juvva@intel.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: Perf tests for hw events
Message-ID: <20150122171102.GH12079@codeblueprint.co.uk>
References: <20150122124014.GF12079@codeblueprint.co.uk>
 <20150122125952.GA3073@kernel.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20150122125952.GA3073@kernel.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 22 Jan, at 09:59:52AM, Arnaldo Carvalho de Melo wrote:
> 
> At some point 'perf test' should grow infrastructure to specify what is
> required for a test so that it auto-skips those, possibly not even
> bothering the user telling something can't be tested. Right now for
> things like tests that requires finding a vmlinux, if it doesn't find
> it, it will just print "Skipped", etc.

Yeah, that makes sense. I'll take a look at that.

-- 
Matt Fleming, Intel Open Source Technology Center
