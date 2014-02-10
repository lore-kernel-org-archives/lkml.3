Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752098AbaBJEPB (ORCPT <rfc822;w@1wt.eu>);
	Sun, 9 Feb 2014 23:15:01 -0500
Received: from mail.wdtv.com ([66.118.69.84]:48489 "EHLO mail.wdtv.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751691AbaBJEPA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 9 Feb 2014 23:15:00 -0500
From: Gene Heskett <gheskett@wdtv.com>
To: Randy Dunlap <rdunlap@infradead.org>, Ken Moffat <zarniwhoop@ntlworld.com>,
        linux-kernel@vger.kernel.org
Subject: make oldfonfig broken.
Date: Sun, 9 Feb 2014 23:14:57 -0500
References: <1391971686-9517-1-git-send-email-richard@nod.at> <201402092246.59715.gheskett@wdtv.com> <52F84E38.7020001@infradead.org>
In-Reply-To: <52F84E38.7020001@infradead.org>
MIME-Version: 1.0
Content-Type: Text/Plain;
  charset="windows-1256"
Content-Transfer-Encoding: 8bit
Message-Id: <201402092314.58129.gheskett@wdtv.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sunday 09 February 2014, Randy Dunlap wrote:
>On 02/09/2014 07:46 PM, Gene Heskett wrote:
>> On Sunday 09 February 2014, Randy Dunlap wrote:
>>> On 02/09/2014 07:07 PM, Ken Moffat wrote:
>>>> On Sun, Feb 09, 2014 at 06:05:41PM -0500, Gene Heskett wrote:
>>>>> On Sunday 09 February 2014, Paul Bolle wrote:
>>>>>> Feel free to open a new thread, with the relevant details, and
>>>>>> involve the relevant people and lists. I have no idea what you're
>>>>>> going on about and could not care less (in the context of this
>>>>>> thread).
>>>>>> 
>>>>>> 
>>>>>> Paul Bolle
>>>>> 
>>>>> Been tried, got zero response.  Frankly, posting just to lkml,
>>>>> hoping the revalent people see it, is beginning to act like posting
>>>>> to a black hole.
>>>>> 
>>>>  I saw one response to you, from Randy Dunlap, asking for more
>>>> 
>>>> information : https://lkml.org/lkml/2014/2/8/153
>>> 
>>> wow, I don't know how I saw this message (thanks, Ken),
>>> but replying to this patch was NOT the right thing to do, Gene.
>>> 
>>> Just reply to my request and I'll be glad to look into it.
>>> 
>>>>  After your posts a few days ago, I'm tempted to suggest you check
>>>> 
>>>> your spam filters, and also any mail files your virus scanner might
>>>> have quarantined.  But it is also possible that you just haven't
>>>> received it - email is like that.
>>>> 
>>>> ؤ¸en
>> 
>> Spam and viri filters watched carefully.  I also use mailfilter, and
>> watch its logs full time for FP's.
>
>Still -- this ATSC problem should not be part of a reply to the Remove
>DEPRECATED patch.

True.  But I got some attention.

>> And I didn't reply because the question seemed way too broad, almost as
>> if
>
>what question seemed to broad?

You wanted to see "a" config, but I wanted to show the diffs. Also 
yesterday I hadn't gone thru what I have yet to see where it falls apart.
>
>> my lament wasn't read.  That and the mail server doesn't like big
>
>what mail server?  yours?  wdtv?  vger.kernel.org certainly has no
>problem with them.

I have gotten bounced from lkml because a screen shot pix of a failed boot 
was too big.  Perhaps 18 months or so.  It was big, from a 10 megapixel 
camera.

>> attachments. So rather than reply to the list, I'll excise some of the
>> addresses that bounce from a reply_all or don't like me, and send the
>> .config from a 3.019 build which seems ok, but by the time that config
>> is run thru a make oldconfig at 3.8.2, most all the media, ATSC and
>> DVB stuff is gone.  So I'll attach that one too.  The later file grew
>> 22kb, but wholesale parts of the first one are missing from the 2nd.
>
>Gene, I want to make sure where you are saying the problem is.
>Is it going directly from 3.019 to 3.8.2, with no intervening kernel
>versions?

No, one intermediate step in this case.

I started with 3.0.19, which was fine, took that one to 3.2.40, and that 
one to 3.8.2 because I don't have anything between those here.  Not exactly 
a step by step.

>I don't know what kernel version 3.019 is.  Do you mean 3.0.19?

Yes, Joanne Dow would call that a typu for sure.

Thanks Randy.

Cheers, Gene
-- 
"There are four boxes to be used in defense of liberty:
 soap, ballot, jury, and ammo. Please use in that order."
-Ed Howdershelt (Author)
Genes Web page <http://geneslinuxbox.net:6309/gene>

NOTICE: Will pay 100 USD for an HP-4815A defective but
complete probe assembly.

