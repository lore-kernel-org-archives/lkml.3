Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752134Ab3HUNmw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Aug 2013 09:42:52 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:33431 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751670Ab3HUNmt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Aug 2013 09:42:49 -0400
X-Authority-Analysis: v=2.0 cv=e9yEuNV/ c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=wom5GMh1gUkA:10 a=roXeUe4e85gA:10 a=5SG0PmZfjMsA:10 a=kj9zAlcOel0A:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=JzSCUfRX3cwA:10 a=4NRdzSatcP40QqvyGe0A:9 a=CjuIK1q_8ugA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Date: Wed, 21 Aug 2013 09:42:48 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Josh Boyer <jwboyer@fedoraproject.org>
Cc: Greg KH <gregkh@linuxfoundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        stable <stable@vger.kernel.org>, lwn@lwn.net,
        Guenter Roeck <linux@roeck-us.net>, Hugh Dickins <hughd@google.com>,
        Johannes Berg <johannes@sipsolutions.net>,
        Borislav Petkov <bp@alien8.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Proposed stable release changes
Message-ID: <20130821134248.GB16493@home.goodmis.org>
References: <20130820224032.GA20491@kroah.com>
 <CA+5PVA4s8D6Hkvj7c4Hpw6MOefZG4BEEWZjWb4XHW+k4n_sWjA@mail.gmail.com>
 <20130820235700.GA7209@kroah.com>
 <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+5PVA4q1K9iS0-ppZKMM8QfKQZBHX8auEp+C=Y=gnSMCkbP2Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Aug 20, 2013 at 08:41:23PM -0400, Josh Boyer wrote:
> 
> Let me phrase this as a question instead.  Is there something we can
> do to help catch the patches that get sucked into stable during the
> merge window and then wind up causing issues and reverted/fixed after
> things settle down in the -rc releases?

I'm curious. Of the patches that went into stable that caused problems,
how many were from the merge window?

Reason that I ask this, is because the patches I tag for stable that I
wait for a merge window for release, goes through the process of all my
patches that enter the merge window. It sits in linux-next for a while
and usually gets much more testing than a fix that may come later in the
-rc cycles.

Personally, I still let my stable patches that go into later -rc sit
in linux-next for a few days before pushing them to mainline. I may even
wait for the next -rc to push it just to make sure the patch wont cause
more issues. But I know others that just send the fix directly to
mainline without going through linux-next. Those, I would think, are the
most prone to cause issues in stable.

-- Steve

