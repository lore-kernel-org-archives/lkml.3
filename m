Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755074Ab3HBXvq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 19:51:46 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:52797 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789Ab3HBXvp convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 19:51:45 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Felipe Contreras <felipe.contreras@gmail.com>
Cc: Aaron Lu <aaron.lwe@gmail.com>, linux-kernel@vger.kernel.org,
        linux-acpi@vger.kernel.org, Len Brown <lenb@kernel.org>,
        Zhang Rui <rui.zhang@intel.com>, Jiri Kosina <trivial@kernel.org>
Subject: Re: [PATCH 2/3] acpi: video: trivial style cleanups
Date: Sat, 03 Aug 2013 02:01:57 +0200
Message-ID: <3692149.CN6y0aXjQ7@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <CAMP44s2oYm+iE-BYu93-bniTRPiu_LZWSAmAd8xEoNSZJbjemQ@mail.gmail.com>
References: <1375400641-1694-1-git-send-email-felipe.contreras@gmail.com> <2112254.EC1eeAtOxW@vostro.rjw.lan> <CAMP44s2oYm+iE-BYu93-bniTRPiu_LZWSAmAd8xEoNSZJbjemQ@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, August 02, 2013 12:56:09 PM Felipe Contreras wrote:
> On Fri, Aug 2, 2013 at 9:09 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > On Thursday, August 01, 2013 11:18:34 PM Felipe Contreras wrote:
> >> On Thu, Aug 1, 2013 at 8:55 PM, Aaron Lu <aaron.lwe@gmail.com> wrote:
> >> > On 08/02/2013 07:44 AM, Felipe Contreras wrote:
> >> >> Signed-off-by: Felipe Contreras <felipe.contreras@gmail.com>
> >> >
> >> > Change log please.
> >>
> >> You mean a commit message?
> >
> > No.  He meant the part that goes between the subject and the signoff.
> > This is called a change log (or changelog).
> 
> Not in Git lingo.
> 
> % man git commit
> 
> "Though not required, it’s a good idea to begin the commit message
> with a single short (less than 50 character) line summarizing the
> change, followed by a blank line and then a more thorough
> description."

Please go and read this: https://lwn.net/Articles/560392/

Now, you may still argue that your patches fall into the "add missing include
of foo.h" category, but it does several different things:
- fixes some whitespace,
- fixes a couple of static variable initializations,
- removes some braces,
- changes the placement of some lables (some of them unnecessarily).

It would be simply *nice* to write what it does in the changelog so that
people reading the git log don't have to look deeper to see what changes the
author meant as "trivial style cleanups".

That's just a matter of making it easier to work with you for other people,
but maybe you just want to be difficult to work with in the first place?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
