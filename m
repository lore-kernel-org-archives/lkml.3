Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751310AbaH3CzL (ORCPT <rfc822;w@1wt.eu>);
	Fri, 29 Aug 2014 22:55:11 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:53304 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750801AbaH3CzJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 29 Aug 2014 22:55:09 -0400
MIME-Version: 1.0
In-Reply-To: <F5184659D418E34EA12B1903EE5EF5FD015DCAE7ABB8@seldmbx02.corpusers.net>
References: <20140819163621.GA15109@linux.vnet.ibm.com>
	<CACxGe6vUXr_uqLG_98oAgbcjddsNgXWdGMrtJ8t23tQ1+z5iag@mail.gmail.com>
	<CAKocOOMG91D7Qam5PLY0Dd7bR07GMHHYsRCqUMYQGCR-hB2+=w@mail.gmail.com>
	<F5184659D418E34EA12B1903EE5EF5FD015DCAE7ABA1@seldmbx02.corpusers.net>
	<F5184659D418E34EA12B1903EE5EF5FD015DCAE7ABB8@seldmbx02.corpusers.net>
Date: Fri, 29 Aug 2014 20:55:08 -0600
Message-ID: <CAKocOOOqSPGjvJcfn_HFZgbZDRH2WFqpTJVBip2jNfhEDYEv2w@mail.gmail.com>
Subject: Re: [kselftest] kselftest wiki (was RE: [Ksummit-discuss] Fwd: Rough
 notes from testing unconference)
From: Shuah Khan <shuahkhan@gmail.com>
To: "Bird, Tim" <Tim.Bird@sonymobile.com>
Cc: Grant Likely <grant.likely@secretlab.ca>,
        "ksummit-discuss@lists.linuxfoundation.org" 
	<ksummit-discuss@lists.linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-api@vger.kernel.org" <linux-api@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 29, 2014 at 7:09 PM, Bird, Tim <Tim.Bird@sonymobile.com> wrote:
> On Saturday, August 23, 2014 6:35 AM, Bird, Tim wrote:
>> Also, I've requested a 'test' wiki on kernel.org, where we can place
>> notes, ideas, and lists of things to work on, or things in progress
>> (like possible output format guidelines).
>>
>> I'll let everyone know when the wiki is set up.
>
> There is now a kselftest wiki on kernel.org at:
> https://kselftest.wiki.kernel.org/
>
> I believe anyone with a Linux Foundation account can edit it.
> I have put together a main page, along with a few sub-pages for
> some of the sub-projects (as I call them) that were discussed at
> the kernel summit.
>
> Please feel free to directly edit the wiki, or to let me know if
> there's any content you'd like to see placed on the wiki.
>

Thanks for doing this.

>
> P.S.  I have copied lkml and linux-api on this.  I believe this is the first
> use of linux-api for discussions about kselftest.  If the linux-api maintainers
> would prefer we get our own list, please let me know.

I spoke to a few folks and gave a heads up to Michael Kerrisk about using
linux-api for kselftest - so far no objections to using it. I sent in
a patch adding
entry for Kselftest framework to MAINTAINERS file with linux-api as the
mailing list. I have a git for this:

git git://git.kernel.org/pub/scm/shuah/linux-kselftest

I couldn't edit the wiki to add this detail even after logging into my
LF account.
Might have to request for access perhaps.

thanks,
-- Shuah
