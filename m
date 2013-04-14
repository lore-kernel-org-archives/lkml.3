Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751950Ab3DNPNM (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Apr 2013 11:13:12 -0400
Received: from casper.infradead.org ([85.118.1.10]:41541 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751873Ab3DNPNK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Apr 2013 11:13:10 -0400
Message-ID: <516AC775.8050004@infradead.org>
Date: Sun, 14 Apr 2013 08:12:53 -0700
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130329 Thunderbird/17.0.5
MIME-Version: 1.0
To: Rob Landley <rob@landley.net>
CC: Borislav Petkov <bp@alien8.de>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>, X86 ML <x86@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: Re: [PATCH] doc: Hold down best practices for pull requests
References: <1365921978.18069.97@driftwood>
In-Reply-To: <1365921978.18069.97@driftwood>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/13/13 23:46, Rob Landley wrote:
> On 04/06/2013 03:55:26 PM, Randy Dunlap wrote:
>> On 03/03/13 04:43, Borislav Petkov wrote:
>> > From: Borislav Petkov <bp@suse.de>
>> >
>> >  Documentation/SubmittingPullRequests | 148 +++++++++++++++++++++++++++++++++++
>> >  1 file changed, 148 insertions(+)
>> >  create mode 100644 Documentation/SubmittingPullRequests
>> >
>> > diff --git a/Documentation/SubmittingPullRequests b/Documentation/SubmittingPullRequests
>> > new file mode 100644
>> > index 000000000000..d123745e0cf5
>> > --- /dev/null
>> > +++ b/Documentation/SubmittingPullRequests
>> > @@ -0,0 +1,148 @@
> 
>> > +1.) The patchset going to an upper level maintainer should NOT be based
>> > +on some random, potentially completely broken commit in the middle of a
>> > +merge window, or some other random point in the tree history.
>> > +
>> > +Tangential to that, it shouldn't contain back-merges - not to "next"
>> > +trees, and not to a "random commit of the day" in Linus' tree.
> 
> Could you do positive advice first instead of negative advice? "Base your tree on a release version, and never re-pull between releases without a damn good reason."
> 
> Not "don't do this, don't do this, don't do this" and make them figure out what they _should_ do by process of elimination.

agreed.

>> > +Here's Linus counting the ways why you shouldn't make merges yourself:
>> > +
>> > +" - I'm usually a day or two behind in my merge queue anyway, partly
>> > +because I get tons of pull requests in a short while and I just want
>> > +to get a feel for what's going on, and partly because I tend to do
>> > +pulls in waves of "ok, I'm going filesystems now, then I'll look at
>>
>>                               doing ?
>>
>> > +drivers".
> 
> Given that he's quoting linus, it would be "[doing]".

ack.

>> > +8.) After the maintainer has pulled, it is always a good idea to take a
>> > +look at the merge and verify it has happened as you've expected it to,
>> > +maybe even run your tests on it to double-check everything went fine.
>> > +
>> > +Further reading: Documentation/development-process/*
>> >
>>
>> Looks good and useful overall.
> 
> Looks longer than necessary to me, and if we have a Documentation/development-process why isn't this going in there instead of at the top level? (Although really why isn't it just another couple bullet points under submittingpatches?)

Well, yes, my first thought was actually why not update SubmittingPatches
instead of add this new file.

-- 
~Randy
