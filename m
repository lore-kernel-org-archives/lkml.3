Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753852AbaCMJa6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Mar 2014 05:30:58 -0400
Received: from tundra.namei.org ([65.99.196.166]:37602 "EHLO tundra.namei.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753593AbaCMJa4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Mar 2014 05:30:56 -0400
Date: Thu, 13 Mar 2014 20:33:06 +1100 (EST)
From: James Morris <jmorris@namei.org>
To: Kees Cook <keescook@chromium.org>
cc: Andrew Morton <akpm@linux-foundation.org>,
        "jwboyer@fedoraproject.org" <jwboyer@fedoraproject.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "gregkh@linuxfoundation.org" <gregkh@linuxfoundation.org>,
        "linux-security-module@vger.kernel.org" 
	<linux-security-module@vger.kernel.org>,
        "hpa@zytor.com" <hpa@zytor.com>,
        Matthew Garrett <matthew.garrett@nebula.com>
Subject: Re: Trusted kernel patchset for Secure Boot lockdown
In-Reply-To: <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
Message-ID: <alpine.LRH.2.02.1403132031460.11638@tundra.namei.org>
References: <1393445473-15068-1-git-send-email-matthew.garrett@nebula.com> <CA+5PVA4RSh3hzJxEjpzHPj8w3uPoEzfg7ySWjB=6RUhAKJTudQ@mail.gmail.com> <alpine.LRH.2.02.1402281402090.26521@tundra.namei.org> <1394686919.25122.2.camel@x230>
 <CAGXu5jJ_8w7PscwTQG5iVRJ4k4nzvN8oqzAPgV+NExAr9v17EQ@mail.gmail.com>
User-Agent: Alpine 2.02 (LRH 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 12 Mar 2014, Kees Cook wrote:

> On Wed, Mar 12, 2014 at 10:01 PM, Matthew Garrett
> <matthew.garrett@nebula.com> wrote:
> > On Fri, 2014-02-28 at 14:03 +1100, James Morris wrote:
> >
> >> Ok, which tree should take this?  I'm happy to, although most of it is
> >> outside security/ .
> >
> > Should I be looking for someone else to take them instead? :)
> 
> Andrew, is this series[1] something you'd be okay taking? It touches
> many different areas, so you might be best for it.

I'll take it, but there's unanswered review feedback (your response to the 
first question), and Alan raised some doubts about the patches which I'm 
not sure have been resolved.



-- 
James Morris
<jmorris@namei.org>
