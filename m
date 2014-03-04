Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756933AbaCDJMi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 04:12:38 -0500
Received: from extern.plris.com ([212.199.10.23]:54504 "EHLO plris.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756667AbaCDJMa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 04:12:30 -0500
X-Greylist: delayed 1103 seconds by postgrey-1.27 at vger.kernel.org; Tue, 04 Mar 2014 04:12:30 EST
From: Leon Pollak <leonp@plris.com>
To: Brian Norris <computersforpeace@gmail.com>
Cc: Richard Weinberger <richard@nod.at>, linux-mtd@lists.infradead.org,
        Linux Kernel <linux-kernel@vger.kernel.org>,
        Al Viro <viro@zeniv.linux.org.uk>,
        Artem Bityutskiy <dedekind1@gmail.com>
Subject: Re: What is wrong?
Date: Tue, 04 Mar 2014 10:54:04 +0200
Message-ID: <20500571.Fgyz0I6ATm@leonp.plris.com>
Organization: PLR Information Systems
User-Agent: KMail/4.11.5 (Linux/3.12.9-201.fc19.x86_64; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20140304083325.GJ13420@norris-Latitude-E6410>
References: <4315632.KkRm7kzq26@leonp.plris.com> <20140303211336.GA7369@gmail.com> <20140304083325.GJ13420@norris-Latitude-E6410>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello, all.

I am really sorry for the silence - I was on the business trip and 
returned today.

I will recheck everything and try. Meanwhile, the news are not good: our 
guys say that it appears that the additional sync DOES NOT SOLVE the 
issue.
I ask for excuse, but as I did not know the exact processing, I was 
mistaken and, probably, used already gc-ted unit for tests.

Sorry, again.

BR

On Tuesday 04 March 2014 00:33:25 Brian Norris wrote:
> On Mon, Mar 03, 2014 at 03:13:36PM -0600, Andrew Ruder wrote:
> > On Thu, Feb 27, 2014 at 01:22:08PM -0800, Brian Norris wrote:
> > > Perhaps Richard or Andrew can comment on whether this patch should
> > > help you. But I think JFFS2 on NAND uses write-buffered support
> > > which can be affected by this bug.
> > 
> > Definitely sounds like the same issue and I'm kind of glad to see it
> > crop up in another filesystem.
> 
> We haven't confirmed that the *patch* actually affects Leon's problem;
> just that if he runs an additional 'sync' it solves his problem.
> Leon, did you get to try the patch?
> 
> Anyway, should commit 807612db2f9940b9fa6deaef054eb16d51bd3e00 be
> marked for -stable?
> 
> Brian

-- 
Leon
