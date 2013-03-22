Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1423383Ab3CVWOz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Mar 2013 18:14:55 -0400
Received: from mx1.redhat.com ([209.132.183.28]:47331 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1422662Ab3CVWOx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Mar 2013 18:14:53 -0400
Date: Fri, 22 Mar 2013 18:14:44 -0400
From: Josh Boyer <jwboyer@redhat.com>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Kees Cook <keescook@chromium.org>, Eric Paris <eparis@redhat.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Christian Kujau <lists@nerdbynature.de>,
        "# 3.4.x" <stable@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] kmsg: Honor dmesg_restrict sysctl on /dev/kmsg
Message-ID: <20130322221444.GJ15821@hansolo.jdub.homelinux.org>
References: <20130222181856.GA2419@hansolo.jdub.homelinux.org>
 <20130227175427.GQ26411@outflux.net>
 <20130227180145.GH2071@hansolo.jdub.homelinux.org>
 <CAGXu5j+ntBM5ZwO9Xqa3sWaEW3nSpR8wsL7poTJ6wZOp5x0Lhw@mail.gmail.com>
 <1361998001.2110.22.camel@localhost>
 <20130227221954.GJ2071@hansolo.jdub.homelinux.org>
 <CAGXu5j+aADfSpBcz9=LVtREQQiW4d3Jd8t7nQKbih7oUhvQghg@mail.gmail.com>
 <20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130322145448.f44f9d10a36620c1c11535b7@linux-foundation.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Mar 22, 2013 at 02:54:48PM -0700, Andrew Morton wrote:
> 
> poke.  Nothing got applied.  I'll drop
> kmsg-honor-dmesg_restrict-sysctl-on-dev-kmsg.patch, see if that has any
> effect ;) 

Oh dear.

Eric, were you going to cleanup your suggestion and send it out?

josh
