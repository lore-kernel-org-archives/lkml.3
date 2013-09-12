Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753555Ab3ILHDf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 03:03:35 -0400
Received: from nat28.tlf.novell.com ([130.57.49.28]:41323 "EHLO
	nat28.tlf.novell.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475Ab3ILHDe convert rfc822-to-8bit (ORCPT
	<rfc822;groupwise-linux-kernel@vger.kernel.org:10:1>);
	Thu, 12 Sep 2013 03:03:34 -0400
Message-Id: <5231836102000078000F29AD@nat28.tlf.novell.com>
X-Mailer: Novell GroupWise Internet Agent 12.0.2 
Date: Thu, 12 Sep 2013 08:03:29 +0100
From: "Jan Beulich" <JBeulich@suse.com>
To: "Kees Cook" <keescook@chromium.org>, "Joe Perches" <joe@perches.com>
Cc: "David Miller" <davem@davemloft.net>, "Eldad Zack" <eldad@fogrefinery.com>,
        "George Spelvin" <linux@horizon.com>,
        "Randy Dunlap" <rdunlap@infradead.org>,
        "Andrew Morton" <akpm@linux-foundation.org>,
        "Dan Carpenter" <dan.carpenter@oracle.com>,
        "Jiri Kosina" <jkosina@suse.cz>, "LKML" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] vsprintf: drop comment claiming %n is ignored
References: <20130911193040.GA16688@www.outflux.net>
 <1378929961.4714.21.camel@joe-AO722>
 <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
In-Reply-To: <CAGXu5jKRmp_Ei=ty05W3SSqQ01agEMDVMGnZCFqQ_yYbZmMSmw@mail.gmail.com>
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8BIT
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>> On 11.09.13 at 22:18, Kees Cook <keescook@chromium.org> wrote:
> On Wed, Sep 11, 2013 at 1:06 PM, Joe Perches <joe@perches.com> wrote:
>> On Wed, 2013-09-11 at 12:30 -0700, Kees Cook wrote:
>>> The %n format is not ignored, so remove the incorrect comment about it.
>>
>> I think it may be better to reimplement the ignoring.
> 
> Yeah, just had a quick look, and scanf doesn't use this code at all.
> I'd much rather remove %n again instead.

Why would you want to artificially make the function diverge
from the spec? People shouldn't be caught by surprises if at all
possible, and one can certainly not expect people to go look at
the comment before the function implementation to find out
what basic (standard) features _do not_ work (one can expect
so when trying to find out about _extensions_).

Jan

