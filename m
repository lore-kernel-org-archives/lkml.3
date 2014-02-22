Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752506AbaBVXFH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 22 Feb 2014 18:05:07 -0500
Received: from merlin.infradead.org ([205.233.59.134]:37941 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaBVXFF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 22 Feb 2014 18:05:05 -0500
Message-ID: <53092D19.7000306@infradead.org>
Date: Sat, 22 Feb 2014 15:04:57 -0800
From: Randy Dunlap <rdunlap@infradead.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Josh Triplett <josh@joshtriplett.org>
CC: Andrew Morton <akpm@linux-foundation.org>, Borislav Petkov <bp@suse.de>,
        Rob Landley <rob@landley.net>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH RESEND 2/3] SubmittingPatches: Add recommendation for
 mailing list references
References: <6f68169828300d32c4266a6d68c5fcf272dfea33.1393099913.git.josh@joshtriplett.org> <02737d618daecb42e33308ce5dabd53ed3cf14f3.1393099913.git.josh@joshtriplett.org> <53091D26.4020900@infradead.org> <20140222223038.GA4643@thin>
In-Reply-To: <20140222223038.GA4643@thin>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/22/2014 02:30 PM, Josh Triplett wrote:
> On Sat, Feb 22, 2014 at 01:56:54PM -0800, Randy Dunlap wrote:
>> On 02/22/2014 12:12 PM, Josh Triplett wrote:
>>> SubmittingPatches already mentions referencing bugs fixed by a commit,
>>> but doesn't mention citing relevant mailing list discussions.  Add a
>>> note to that effect, along with a recommendation to use the
>>> https://lkml.kernel.org/ redirector.
>>>
>>> Portions based on text from git's SubmittingPatches.
>>>
>>> Signed-off-by: Josh Triplett <josh@joshtriplett.org>
>>> Acked-by: Borislav Petkov <bp@suse.de>
>>> ---
>>>  Documentation/SubmittingPatches | 10 +++++++++-
>>>  1 file changed, 9 insertions(+), 1 deletion(-)
>>>
>>> diff --git a/Documentation/SubmittingPatches b/Documentation/SubmittingPatches
>>> index c74e73c..53e6590 100644
>>> --- a/Documentation/SubmittingPatches
>>> +++ b/Documentation/SubmittingPatches
>>> @@ -112,7 +112,15 @@ to do frotz", as if you are giving orders to the codebase to change
>>>  its behaviour.
>>>  
>>>  If the patch fixes a logged bug entry, refer to that bug entry by
>>> -number and URL.
>>> +number and URL.  If the patch follows from a mailing list discussion,
>>> +give a URL to the mailing list archive; use the https://lkml.kernel.org/
>>> +redirector with a Message-Id, to ensure that the links cannot become
>>> +stale.
>>
>> Some of us don't know what that looks like.
>> Could we have an example?
> 
> https://lkml.kernel.org/ provides examples; I didn't want to duplicate
> that documentation.

Thanks, I didn't know that and wouldn't normally look there to see if
it provides examples, so you could do like Boris suggested... :)


-- 
~Randy
