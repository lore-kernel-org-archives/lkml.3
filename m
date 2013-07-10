Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754882Ab3GJXpO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Jul 2013 19:45:14 -0400
Received: from terminus.zytor.com ([198.137.202.10]:35761 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754110Ab3GJXpM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Jul 2013 19:45:12 -0400
Message-ID: <51DDF1FB.5010709@zytor.com>
Date: Wed, 10 Jul 2013 16:44:59 -0700
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130625 Thunderbird/17.0.7
MIME-Version: 1.0
To: "Theodore Ts'o" <tytso@mit.edu>, Steven Rostedt <rostedt@goodmis.org>,
        ksummit-2013-discuss@lists.linuxfoundation.org,
        linux-kernel@vger.kernel.org
Subject: Re: [Ksummit-2013-discuss] [ATTEND] What to do when a maintainer
 is no longer available
References: <1373489151.7458.80.camel@gandalf.local.home> <20130710222206.GE28076@thunk.org>
In-Reply-To: <20130710222206.GE28076@thunk.org>
X-Enigmail-Version: 1.5.1
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 07/10/2013 03:22 PM, Theodore Ts'o wrote:
> 
> I agree this is an important thing to do, but I'm hesitant about
> having someone formally annointed as "the successor".  Information in
> the MAINTAINERS file can get stale, and removing someone who may not
> have as much time, and so has become a bit inactive, and replacing him
> or her with someone who might be more active, is a political act which
> can cause feelings to be hurt or otherwise lead to drama.
> 
> It's for the same reason that we don't have a formally designated
> "core team", although people have a pretty good idea who the core
> developers are.
> 
> That being said, maintainers would be well advised to make sure there
> are other people who know enough that they could take over if
> something unfortunate happens, and there are a number of ways helping
> that process along, including delegating as much as possible in terms
> of code reviews, etc., to other subsystem developers.
> 
>> I rather have something in place before it happens. Unfortunately, it
>> will happen. It's just a matter of time.
> 
> It's happened already; for example, when Leonard Zubkoff passed
> away in an unfortunate helicopter accident.
> 

I agree with Ted here... this has not in general been a huge problem
(neither with untimely death nor with other reasons to depart the kernel
community.)  In some ways we are much worse off with the "hanger-on":
the maintainer who is still "officially" in charge but not doing what is
needed.  From personal experience I can say that that phenomenon gets
even worse for the "designated successor" scenario: as the "designated
successor" isn't actually doing the work, it is not at all clear that
they will be capable of shouldering the burden at the particular time
the main maintainer departs.  I had a (non-kernel, but Open Source)
project where I made the mistake of appointing a successor, and found
that the successor in effect prevented anything useful from getting
done... just not enough pressure to not fork the project, and so it died
a long, slow death.  Five years later there still was not a new release,
and no one was interested in the project anymore.

	-hpa


