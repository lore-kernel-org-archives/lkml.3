Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaIYQ2y (ORCPT <rfc822;w@1wt.eu>);
	Thu, 25 Sep 2014 12:28:54 -0400
Received: from relay6-d.mail.gandi.net ([217.70.183.198]:33058 "EHLO
	relay6-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752604AbaIYQ2w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 25 Sep 2014 12:28:52 -0400
X-Originating-IP: 10.58.1.146
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8;
 format=flowed
Content-Transfer-Encoding: 7bit
Date: Thu, 25 Sep 2014 18:28:47 +0200
From: Oscar Utbult <oscar@oscr.io>
To: Frans Klaver <fransklaver@gmail.com>
Cc: Randy Dunlap <rdunlap@infradead.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/1] Changed "&" with "and" in
 Documentation/applying-patches.txt.
In-Reply-To: <CAH6sp9NqiNincavwB9bQ94EvG8ZjvUPLH5u3j04OV2JMz7wTEg@mail.gmail.com>
References: <1411652495-100852-1-git-send-email-oscar@oscr.io>
 <CAH6sp9NqiNincavwB9bQ94EvG8ZjvUPLH5u3j04OV2JMz7wTEg@mail.gmail.com>
Message-ID: <e692e73445c591af1bea3ce0a87755c6@oscr.io>
User-Agent: Roundcube Webmail/0.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 2014-09-25 16:48, Frans Klaver wrote:
> On Thu, Sep 25, 2014 at 3:41 PM,  <oscar@oscr.io> wrote:
>> Subject: [PATCH 1/1] Changed "&" with "and" in 
>> Documentation/applying-patches.txt.
> 
> Documentation/SubmittingPatches says:
> 
> Describe your changes in imperative mood, e.g. "make xyzzy do frotz"
> instead of "[This patch] makes xyzzy do frotz" or "[I] changed xyzzy
> to do frotz", as if you are giving orders to the codebase to change
> its behaviour.

Thank you for your feedback Frans.

So for example a better description would have been: "use 'and' instead 
of '&'"?

> 
>> From: Oscar Utbult <oscar@oscr.io>
>> 
>> http://english.stackexchange.com/questions/3127/when-to-use-instead-of-and
> 
> It might be that a link is enough, but I would prefer to have an
> excerpt from that, possibly with the link as reference.

You are right. I will provide one in the future.

Oscar

> 
> Thanks,
> Frans
> 
>> 
>> Signed-off-by: Oscar Utbult <oscar@oscr.io>
>> ---
>>  Documentation/applying-patches.txt | 2 +-
>>  1 file changed, 1 insertion(+), 1 deletion(-)
>> 
>> diff --git a/Documentation/applying-patches.txt 
>> b/Documentation/applying-patches.txt
>> index a083ba3..77df55b 100644
>> --- a/Documentation/applying-patches.txt
>> +++ b/Documentation/applying-patches.txt
>> @@ -94,7 +94,7 @@ Common errors when patching
>>  ---
>>   When patch applies a patch file it attempts to verify the sanity of 
>> the
>>  file in different ways.
>> -Checking that the file looks like a valid patch file & checking the 
>> code
>> +Checking that the file looks like a valid patch file and checking the 
>> code
>>  around the bits being modified matches the context provided in the 
>> patch are
>>  just two of the basic sanity checks patch does.
>> 
>> --
>> 1.8.0.1
>> 
>> --
>> To unsubscribe from this list: send the line "unsubscribe 
>> linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
