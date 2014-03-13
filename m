Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753932AbaCMKNr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 06:13:47 -0400
Received: from lxorguk.ukuu.org.uk ([81.2.110.251]:34747 "EHLO
	lxorguk.ukuu.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753863AbaCMKNE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 06:13:04 -0400
Date: Thu, 13 Mar 2014 10:12:35 +0000
From: One Thousand Gnomes <gnomes@lxorguk.ukuu.org.uk>
To: James Morris <jmorris@namei.org>
Cc: Kees Cook <keescook@chromium.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
Message-ID: <20140313101235.753c3ec0@alan.etchedpixels.co.uk>
In-Reply-To: <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com>
	<CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com>
	<alpine.LRH.2.02.1402281402090.26521@tundra.namei.org>
	<1394686919.25122.2.camel@x230>
	<CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
	<alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
Organization: Intel Corporation
X-Mailer: Claws Mail 3.8.1 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 13 Mar 2014 20:33:06 +1100 (EST)
James Morris <jmorris@namei.org> wrote:

> On Wed, 12 Mar 2014, Kees Cook wrote:
> 
> > On Wed, Mar 12, 2014 at 10:01 PM, Matthew Garrett
> > <matthew.garrett@nebula.com> wrote:
> > > On Fri, 2014-02-28 at 14:03 +1100, James Morris wrote:
> > >
> > >> Ok, which tree should take this?  I'm happy to, although most of it is
> > >> outside security/ .
> > >
> > > Should I be looking for someone else to take them instead? :)
> > 
> > Andrew, is this series[1] something you'd be okay taking? It touches
> > many different areas, so you might be best for it.
> 
> I'll take it, but there's unanswered review feedback (your response to the 
> first question), and Alan raised some doubts about the patches which I'm 
> not sure have been resolved.

I have a series of doubts about their completeness which didn't get any
answer at all, and one on the misleading use of the term "secure" as
opposed to "measured" 8)

I don't think it's reasonable to have a policy of refusing them until
they cover all cases. It's not like it can be dropped into staging and
refined.

So other than the usual moan about people naming things "security" being
like putting "i-" and "e-" on the front of stuff to make it sound cool
when it isn't what it says I'm fine 8)

I would prefer it did the revocation of CAP_SYS_RAWIO or at least
documented the absolute requirement.

Alan
