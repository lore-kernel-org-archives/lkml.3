Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754513Ab3HaQli (ORCPT <rfc822;w@1wt.eu>);
	Sat, 31 Aug 2013 12:41:38 -0400
Received: from one.firstfloor.org ([193.170.194.197]:36290 "EHLO
	one.firstfloor.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753735Ab3HaQlh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 31 Aug 2013 12:41:37 -0400
Date: Sat, 31 Aug 2013 18:41:35 +0200
From: Andi Kleen <andi@firstfloor.org>
To: Joe Perches <joe@perches.com>
Cc: Andi Kleen <andi@firstfloor.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Andy Whitcroft <apw@canonical.com>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Guenter Roeck <linux@roeck-us.net>, Jean Delvare <khali@linux-fr.org>,
        LKML <linux-kernel@vger.kernel.org>,
        linux-arm-kernel <linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] checkpatch:  Add test for positional misuse of section
 specifiers like __initdata
Message-ID: <20130831164135.GE19750@two.firstfloor.org>
References: <1377655732.3619.19.camel@joe-AO722>
 <20130831143123.GC19750@two.firstfloor.org>
 <1377965049.2054.15.camel@joe-AO722>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377965049.2054.15.camel@joe-AO722>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

> I'll get around to adding tests for your
> cases soonish.

You could also just apply my patch?

AFAIK it works fine.

-Andi
