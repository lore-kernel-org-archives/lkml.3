Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754582Ab3HaQEM (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 12:04:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41843 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1753674Ab3HaQEK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 12:04:10 -0400
Message-ID: <1377965049.2054.15.camel@joe-AO722>
Subject: Re: [PATCH] checkpatch:  Add test for positional misuse of section
 specifiers like __initdata
From: Joe Perches <joe@perches.com>
To: Andi Kleen <andi@firstfloor.org>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Date: Sat, 31 Aug 2013 09:04:09 -0700
In-Reply-To: <20130831143123.GC19750@two.firstfloor.org>
References: <1377655732.3619.19.camel@joe-AO722>
	 <20130831143123.GC19750@two.firstfloor.org>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, 2013-08-31 at 16:31 +0200, Andi Kleen wrote:
> > A similar patch was suggested by Andi Kleen
> > https://lkml.org/lkml/2013/8/5/648
> 
> My patch checked for const <-> initdata / non const initconst  mistakes.
> 
> I don't think your patch does that?

Hi Andi.

No it doesn't.

This patch is just warning when using
	struct __initdata foo bar;
instead of
	struct foo bar __initdata;

I'll get around to adding tests for your
cases soonish.

cheers, Joe

