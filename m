Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751729Ab3EJKMW (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 06:12:22 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61998 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750825Ab3EJKMU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 06:12:20 -0400
Date: Fri, 10 May 2013 12:12:15 +0200
From: "Yann E. MORIN" <yann.morin.1998@free.fr>
To: Wang YanQing <udknight@gmail.com>
Cc: linux-kbuild@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jean Delvare <jdelvare@suse.de>, Michal Marek <mmarek@suse.cz>,
        Roland Eggner <edvx1@systemanalysen.net>
Subject: Re: [PATCH v3] kconfig: sort found symbols by relevance
Message-ID: <20130510101214.GA3302@free.fr>
References: <1367826629.4494.30.camel@chaos.site>
 <1367874931-6251-1-git-send-email-yann.morin.1998@free.fr>
 <20130509152731.GA3355@udknight>
 <20130509161217.GA2948@free.fr>
 <20130510005125.GA2323@udknight>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130510005125.GA2323@udknight>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Wang, All,

On Fri, May 10, 2013 at 08:51:25AM +0800, Wang YanQing wrote:
> On Thu, May 09, 2013 at 06:12:17PM +0200, Yann E. MORIN wrote:
[--SNIP--]
> > For the ten-or-so tests I did, the sorting was rather appropriate,
> > though that's only ten-or-so tests and is not exhaustive (and probably
> > subject to testing bias, too).
> 
> I hope more people will find the sorting is appropriate if Michal Marek accept 
> it :)

OK, I'll queue it in my tree, and will push it to Michal for 3.11, as it
is a bit too late for 3.10, now.

> > > maybe provide mechanism to user will make guesser life easier.
> > Sorry, I can't make sense of this sentence. :-( Can you elaborate a bit
> > what you meant, please?
> 
> The mechanism means first heuristic in previous Email patch.
> 
> I though we could get this heuristic's result by composite your first heuristic
> in previous Email patch with regular expression, it seams like I lost something,
> see above.

OK, so I'll keep it as-is (I will just fix some coding-style issues I've
spotted).

Thanks for the input!

Regards,
Yann E. MORIN.

-- 
.-----------------.--------------------.------------------.--------------------.
|  Yann E. MORIN  | Real-Time Embedded | /"\ ASCII RIBBON | Erics' conspiracy: |
| +33 662 376 056 | Software  Designer | \ / CAMPAIGN     |  ___               |
| +33 223 225 172 `------------.-------:  X  AGAINST      |  \e/  There is no  |
| http://ymorin.is-a-geek.org/ | _/*\_ | / \ HTML MAIL    |   v   conspiracy.  |
'------------------------------^-------^------------------^--------------------'
