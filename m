Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753392AbaFXMKp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 24 Jun 2014 08:10:45 -0400
Received: from mail.phunq.net ([184.71.0.62]:46274 "EHLO starbase.phunq.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752673AbaFXMKo convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 24 Jun 2014 08:10:44 -0400
From: Daniel Phillips <daniel@phunq.net>
To: James Bottomley <James.Bottomley@hansenpartnership.com>
Cc: "Theodore Ts'o" <tytso@mit.edu>, Pavel Machek <pavel@ucw.cz>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        <linux-fsdevel@vger.kernel.org>, Dave Chinner <david@fromorbit.com>
Subject: Re: [RFC] Tux3 for review
Date: Tue, 24 Jun 2014 05:10:36 -0700
User-Agent: Trojita/0.4.1; Qt/4.8.6; X11; Linux; Ubuntu 14.04 LTS
MIME-Version: 1.0
Message-ID: <18a3e3b6-9b41-4ce1-90a6-ae0c3c0c88c8@phunq.net>
In-Reply-To: <1403610735.3140.32.camel@dabdike>
References: <1402932354.2197.61.camel@dabdike.int.hansenpartnership.com>
 <20140619082129.GA4309@xo-6d-61-c0.localdomain>
 <alpine.LFD.2.00.1406191117240.2182@localhost.localdomain>
 <ad0baf8f-091f-45d0-8d9f-f72d78d0d1ff@phunq.net>
 <1403378941.2177.24.camel@dabdike.int.hansenpartnership.com>
 <e475a747-2f33-4c43-b6bd-98df2e57099a@phunq.net>
 <1403448187.1949.9.camel@jarvis.lan>
 <522aee97-34e7-4adc-adf2-c9b73aa0ef36@phunq.net>
 <1403584890.3140.18.camel@dabdike>
 <79582b70-6111-49f5-a1a9-f5701854e199@phunq.net>
 <20140624105940.GH14887@thunk.org>
 <3dd5be85-278b-4e20-a6c2-1e042dab2bef@phunq.net>
 <1403610735.3140.32.camel@dabdike>
Organization: tux3.org
Content-Type: text/plain; charset=utf-8; format=flowed
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, June 24, 2014 4:52:15 AM PDT, James Bottomley wrote:
> On Tue, 2014-06-24 at 04:27 -0700, Daniel Phillips wrote:
>> I emphatically disagree that it is premature for asking Tux3 to be
>> merged. You might think so, but I do not. While I do not begrudge
>> you your opinion, Linux did not get to the dominant position it has
>> today by being shy about merging new functionality early. Did we
>> suddenly lose our mojo just at Tux3 merge time?
>
> But you've agreed to go the core hooks route, the patches for which
> aren't yet ready, so what is there actually to review and merge until
> the patches appear?

If Linus asks for a Tux3 pull first thing tomorrow we will agree to
it, perfect core patches or not. This is because we are confident
that all remaining API issues and code duplication issues are
solvable in the usual Linux way. The Tux3 tree exactly as posted
builds and runs passing well. We do not feel ashamed of it at all,
quite the contrary.

Mind you, we know that everybody is looking forward to a lively
discussion about page forking, as well they should. But it does not
really matter whether that takes place before or after merge. You
know as well as I do that we are collectively smart enough to make
it work, and you probably understand by now why it is worth making
it work. Further, we think it already works, both by analysis and
empirical results of our stress testing.

If you have a _specific_ example of an API issue that is not solvable
in the usual Linux way, please share it.

Regards,

Daniel
