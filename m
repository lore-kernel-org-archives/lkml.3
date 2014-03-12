Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001AbaCLUQc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Mar 2014 16:16:32 -0400
Received: from mail-out.m-online.net ([212.18.0.9]:35244 "EHLO
	mail-out.m-online.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752846AbaCLUQJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Mar 2014 16:16:09 -0400
X-Auth-Info: Y7uBonn00wYIvWjTdReUpiAUc7SnvraMN6r9kaEgTOI=
Date: Wed, 12 Mar 2014 21:16:06 +0100
From: Gerhard Sittig <gsi@denx.de>
To: Linus Walleij <linus.walleij@linaro.org>
Cc: Gary Servin <garyservin@gmail.com>, Alexandre Courbot <gnurou@gmail.com>,
        Jiri Kosina <trivial@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] gpio: mcp23s08: Trivial: Fixed coding style issues
Message-ID: <20140312201606.GN3327@book.gsilab.sittig.org>
References: <1394148326-21556-1-git-send-email-garyservin@gmail.com>
 <CACRpkdbjbjeePQipX7nbLXJKnYWFUXhbDLEXPGX5z+EE8R-q3Q@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACRpkdbjbjeePQipX7nbLXJKnYWFUXhbDLEXPGX5z+EE8R-q3Q@mail.gmail.com>
Organization: DENX Software Engineering GmbH
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 14:53 +0100, Linus Walleij wrote:
> 
> On Fri, Mar 7, 2014 at 12:25 AM, Gary Servin <garyservin@gmail.com> wrote:
> 
> > This coding style issue was detected using the checkpatch.pl script
> >
> > Signed-off-by: Gary Servin <garyservin@gmail.com>
> 
> Sometimes the compiler is just too forgiving :-/
> Thanks a lot for fixing this, patch applied.

I think the code had no syntax or language issue before.  The
cleanup really was about style exclusively (which still is a good
thing).  'sizeof' is an operator, very much like a unary minus or
unary ampersand which neither require parentheses.  So either of
"sizeof(x)" as well as "sizeof x" are legal with regard to the C
language.  It's just that the community prefers "sizeof(x)" for
the improved readability.


virtually yours
Gerhard Sittig
-- 
DENX Software Engineering GmbH,     MD: Wolfgang Denk & Detlev Zundel
HRB 165235 Munich, Office: Kirchenstr. 5, D-82194 Groebenzell, Germany
Phone: +49-8142-66989-0 Fax: +49-8142-66989-80  Email: office@denx.de
