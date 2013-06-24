Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752132Ab3FXRN7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Jun 2013 13:13:59 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:44146 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751894Ab3FXRNy convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Jun 2013 13:13:54 -0400
Date: Mon, 24 Jun 2013 19:13:48 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Jean Delvare <jdelvare@suse.de>, Michal Marek <mmarek@suse.cz>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Roland Eggner <edvx1@systemanalysen.net>,
        Wang YanQing <udknight@gmail.com>
Subject: Re: [PATCH 12/14] kconfig: sort found symbols by relevance
Message-ID: <20130624171348.GA3258@free.fr>
References: <cover.1371595499.git.yann.morin.1998@free.fr>
 <3e2346029e33ef9405b87d72a32d96d0aafb524a.1371595499.git.yann.morin.1998@free.fr>
 <1372060659.4310.41.camel@chaos.site>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1372060659.4310.41.camel@chaos.site>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Jean, Michal, All,

On 2013-06-24 09:57 +0200, Jean Delvare spake thusly:
> Le Wednesday 19 June 2013 à 00:45 +0200, Yann E. MORIN a écrit :
> > When searching for symbols, return the symbols sorted by relevance.
> > 
> > Sorting is done as thus:
> >   - first, symbols with a prompt,   [1]
> >   - then, smallest offset,          [2]
> >   - then, shortest match,           [3]
> >   - then, highest relative match,   [4]
> >   - finally, alphabetical sort      [5]
> > 
> > So, searching (eg.) for 'P.*CI' :
> 
> Nobody would actually search for that, so that's not a particularly good
> example to determine whether your sort order is sane or not.

Yes, this was just to explain the sorting algorithm with a simple
example.

[--SNIP--]
> > This heuristic tries hard to get interesting symbols first in the list.
> 
> I know I am the one whose question triggered this work from you, but in
> the end the "response" seems disproportionate. Having 5 different
> ordering rules is a lot, and that's quite a bit of code, which while not
> the most complex in the world, is still far from trivial and may require
> maintenance work in the future.

OK, I understand you concerns.

Michal, please do not apply this patch: I'll rewrite it with a simpler
heuristic as Jean suggested, and will re-submit a complete pull-request
later tonight.

> So I think it is more important to make it clearer that regular
> expressions are allowed, than to come up with a brilliant sort order. I
> know the help page says it, but the prompt itself only asks for a
> "(sub)string" and it is not immediately obvious (to me at least) that
> regular expressions are considered substrings.

OK, Ill see to rewite the title of the dialog box.

Thanks for the review!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
