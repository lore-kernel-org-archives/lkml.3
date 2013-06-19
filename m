Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935239Ab3FSVBk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:01:40 -0400
Received: from mail-wg0-f45.google.com ([74.125.82.45]:59668 "EHLO
	mail-wg0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935060Ab3FSVBh convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:01:37 -0400
Date: Wed, 19 Jun 2013 23:01:31 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [pull request] Pull request for branch yem-kconfig-for-next
Message-ID: <20130619210131.GA3442@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
 <51C2173E.3080405@suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <51C2173E.3080405@suse.cz>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michal, All,

On 2013-06-19 22:40 +0200, Michal Marek spake thusly:
> Dne 19.6.2013 00:44, Yann E. MORIN napsal(a):
> > From: "Yann E. MORIN" <yann.morin.1998@free.fr>
> > 
> > Hello Michal, All!
> > 
> > These are the patches against kconfig that I have accumulated for 3.11,
> > and for which I plan to later send a proper pull-request.
> > 
> > Note-whorthy this time:
> >   - fix values of tristates that are selected by boolean choices (Arve)
> >   - fix choice randomisation in presence of KCONFIG_ALLCONFIG    (me)
> >   - fix choice randomisation selecting more than one value in
> >     a choice (but only if it is conditional)                     (me)
> >   - fix choice-in-a-choice randomisation not selecting any value
> >     for the inner-most choice                                    (me)
> > 
> > Also, some code-cleanups and eye-candy:
> >   - mconf and nconf code cleanups                                (Dirk, Sedat)
> >   - mconf and nconf eye-candy                                    (Dirk)
> >   - scripts/config script-name in help text                      (Clément)
> >   - heuristic to sort found symbols by relevance                 (me)
> >   - more randconfig debugging help                               (me)
> > 
> > Note: this series is for review before I send an official pull-request.
> > I want to avoid the debacle [0] [1] of the last kconfig breakage I caused
> > with my previous kconfig "fix" to randomising choices in presence of
> > KCONFIG_ALLCONFIG.
> > 
> > I would like to send an official pull-request early next week, so all of
> > these can land early in -next, so they get some real-life t4esting before
> > the next merge windows open. So please, please, test this carefully. ;-)
> 
> I tested this a bit, it works fine. Unless somebody else finds issues,
> I'll merge it.

Could you please wait a few days (say friday, or monday), I know someone
whose supposed to do some testing on his use-case (Hello Thomas! ;-) ).

Thank you!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
