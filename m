Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756401Ab3HFVL3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 17:11:29 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:50560 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755428Ab3HFVL2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 17:11:28 -0400
MIME-Version: 1.0
In-Reply-To: <51FC26C7.8060108@zytor.com>
References: <CAErSpo7eHXC-SXFYuAkkoDdhLoHzsRGh7_36wgc8=j2+qz2btA@mail.gmail.com>
 <CAKocOOMCsuLBsvg3npugW3EK5+UBzvQVvjeVBgTLrGrsp7o9rw@mail.gmail.com> <51FC26C7.8060108@zytor.com>
From: Bjorn Helgaas <bhelgaas@google.com>
Date: Tue, 6 Aug 2013 15:11:05 -0600
Message-ID: <CAErSpo7z7b-i7qENa9q+8jLmsV=EFiykBy5wU1AE3eAMG1MKUA@mail.gmail.com>
Subject: Re: kernel mailing list permalinks
To: "H. Peter Anvin" <hpa@zytor.com>
Cc: Shuah Khan <shuahkhan@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        postmaster@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

[+cc vger postmaster]

On Fri, Aug 2, 2013 at 3:38 PM, H. Peter Anvin <hpa@zytor.com> wrote:
> On 08/02/2013 02:36 PM, Shuah Khan wrote:
>> On Fri, Aug 2, 2013 at 3:04 PM, Bjorn Helgaas <bhelgaas@google.com> wrote:
>>> vger already adds a "to unsubscribe from this list" footer to messages
>>> to LKML and other lists.  What if it also added the lkml.kernel.org
>>> permalink for the message, e.g.,
>>> "http://lkml.kernel.org/r/CA+55aFxb3NT3_04ZLKiCFrtTXSdi4bfQFf0HJviRRYPTW4ymXA@mail.gmail.com"?
>>>
>>> I often use the permalink to cite an email in bugzilla reports,
>>> changelogs, other conversations, etc., and I currently dig out the
>>> message-ID and construct the link by hand, so having the link directly
>>> in the footer would be handy for me.  Would anybody else find this
>>> useful?
>>>
>>> Bjorn
>>
>> +1
>> It would be awesome and very useful to me. I often look for lkml link
>> for messages.
>>
>
> The above link is also a good example of subtleness: + in a URL means a
> space character, it has to be escaped as %2B.  Particularly a problem in
> gmail message-ids.

Ooh, thanks.  I wasn't aware of that, and I've certainly constructed
links that are semi-broken because of this issue.  Having the
permalink in the message footer would avoid that problem.

I don't know what it would take to implement this.  Escaping special
characters makes it not quite as trivial as I thought it might be.

Bjorn
