Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754397Ab3HaOb1 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 10:31:27 -0400
Received: from one.firstfloor.org ([193.170.194.197]:35944 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753043Ab3HaOb0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 10:31:26 -0400
Date: Sat, 31 Aug 2013 16:31:23 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        Andi Kleen <andi@firstfloor.org>, LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] checkpatch:  Add test for positional misuse of section
 specifiers like __initdata
Message-ID: <20130831143123.GC19750@two.firstfloor.org>
References: <1377655732.3619.19.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377655732.3619.19.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> A similar patch was suggested by Andi Kleen
> https://lkml.org/lkml/2013/8/5/648

My patch checked for const <-> initdata / non const initconst  mistakes.

I don't think your patch does that?

-Andi
