Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaL1IjF (ORCPT <rfc822;w@1wt.eu>);
	Sun, 28 Dec 2014 03:39:05 -0500
Received: from e06smtp13.uk.ibm.com ([195.75.94.109]:44148 "EHLO
	e06smtp13.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751249AbaL1IjC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 28 Dec 2014 03:39:02 -0500
Message-ID: <549FC19F.4050504@de.ibm.com>
Date: Sun, 28 Dec 2014 09:38:55 +0100
From: Christian Borntraeger <borntraeger@de.ibm.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.3.0
MIME-Version: 1.0
To: Stephen Rothwell <sfr@canb.auug.org.au>,
        Linus Torvalds <torvalds@linux-foundation.org>
CC: linux-next <linux-next@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: linux-next: missing merge fix for the access_once tree
References: <20141223131749.78087632@canb.auug.org.au> <CA+55aFxjeunxnfc8L1r=GWCBUf5uU=bcnDeu6VygMbsCxVgB0Q@mail.gmail.com> <20141223173418.59e8556f@canb.auug.org.au>
In-Reply-To: <20141223173418.59e8556f@canb.auug.org.au>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14122808-0013-0000-0000-0000025C698B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 23.12.2014 um 07:34 schrieb Stephen Rothwell:
> Hi Linus,
> 
> On Mon, 22 Dec 2014 20:12:22 -0800 Linus Torvalds <torvalds@linux-foundation.org> wrote:
>>
>> On Mon, Dec 22, 2014 at 6:17 PM, Stephen Rothwell <sfr@canb.auug.org.au> wrote:
>>>
>>> I have been carrying this merge fix patch for some time.  It should
>>> have gone into the merge of the access_once tree.
>>
>> No, you had a different tree that got merged into linux-next, that
>> made it an error to do ACCESS_ONCE() on a structure.
>>
>> The thing I merged didn't actually have that final commit, exactly so
>> that things wouldn't break from missing conversions.
>>
>> So that patch isn't wrong, but it also isn't exactly a required fix
>> until the next merge window..
> 
> True, so "should" was a bit strong.
> 

I will re-add this up soon for my linux-next branch. 
There are some additional places which need to be changed, so give me some more days during the holidays

Christian

