Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752671AbaBUGwc (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 01:52:32 -0500
Received: from mail-ee0-f47.google.com ([74.125.83.47]:65027 "EHLO
	mail-ee0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751237AbaBUGwa (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 01:52:30 -0500
Message-ID: <5306F7A3.8050608@gmail.com>
Date: Fri, 21 Feb 2014 08:52:19 +0200
From: Boaz Harrosh <openosd@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: Linux 3.14-rc3
References: <CA+55aFyvQ4ko4J2oLbyVEZjb9=TvjcCF_PV-jGDZTR8_D+zseQ@mail.gmail.com>
In-Reply-To: <CA+55aFyvQ4ko4J2oLbyVEZjb9=TvjcCF_PV-jGDZTR8_D+zseQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/16/2014 11:57 PM, Linus Torvalds wrote:
> When I made the rc2 announcement, I mentioned how nice and small it
> was. I also mentioned that I mistrusted you guys, and that I suspected
> that some people were giggling to themselves and holding back their
> pull requests, evil little creatures like you are.
> 
> And I hate being right. rc2 was quite small, but rc3 makes up for it.
> I quietly took all the pull requests because clearly this wasn't a
> surprise, but I'm warning you - I'm going to start cursing at people
> if it looks like this trend is going to continue. You've been warned.
> 

I do not think it is any evil doing but a pattern. (But I suspect you
know that). After rc1 there is a two weeks pause hence the small rc2.
This is because trees need to be rebased. Fixes sorted out from next
window development. And everyone is testin, retesting on top of the
just released new Kernel (10,000 patches big). So it might be a sign
for a good thing, no? rc3 is all the breakage found in 2 weeks of
testing.

Just my $0.017
Boaz

> Anyway, because the shortlog is pretty hefty, I'm doing my overview
> "mergelog" here, and will post the shortlog separately as a reply to
> this email for people who want more detail. The bulk is the networking
> and random drivers (net, staging, usb, block, infiniband..) but
> there's some arch updates too (powerpc, arm, x86) and some
> documentation updates.
> 
>           Linus
> 
> (And as always for my mergelog - the people credited are the people
> who send me the pull request, which is generally different from the
> author of the code. See the shortlog for actual code authorship)
> 

