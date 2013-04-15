Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750904Ab3DOEAM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Apr 2013 00:00:12 -0400
Received: from perches-mx.perches.com ([206.117.179.246]:41673 "EHLO
	labridge.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org with ESMTP
	id S1750715Ab3DOEAK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Apr 2013 00:00:10 -0400
Message-ID: <1365998409.1878.29.camel@joe-AO722>
Subject: Re: [PATCH 1/2] hfs/hfsplus: Convert dprint to hfs_dbg
From: Joe Perches <joe@perches.com>
To: htl10@users.sourceforge.net
Cc: Vyacheslav Dubeyko <slava@dubeyko.com>, linux-fsdevel@vger.kernel.org,
        linux-kernel@vger.kernel.org
Date: Sun, 14 Apr 2013 21:00:09 -0700
In-Reply-To: <1365997619.11055.YahooMailClassic@web172306.mail.ir2.yahoo.com>
References: <1365997619.11055.YahooMailClassic@web172306.mail.ir2.yahoo.com>
Content-Type: text/plain; charset="ISO-8859-1"
X-Mailer: Evolution 3.6.2-0ubuntu0.1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-04-15 at 04:46 +0100, Hin-Tak Leung wrote:
> > By converting this dprint() to pr_debug(), it would
> > print out on a multiple lines, one for each read.
> > 
> > That's why it should use a mechanism like dbg_cont.
> > 
> > btw: there is no current pr_debug_cont mechanism.
> 
> That's rubbish.

Don't be silly.

> dprint() are compiled in/out debug printing statements,
> and are entirely suppressed in unmodified kernel source

Of course.

> I am not saying what I have in private is correct

Then your original post wasn't useful either.

> What I am saying is that the code snipplet I posted is functional:

Lots of code is functional, I prefer functional
and correct though.

cheers, Joe

