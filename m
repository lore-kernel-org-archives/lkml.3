Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752661AbaHIBWZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 21:22:25 -0400
Received: from mail-vc0-f181.google.com ([209.85.220.181]:46793 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751289AbaHIBWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 21:22:21 -0400
MIME-Version: 1.0
In-Reply-To: <20140809001010.GA9437@jtriplet-mobl1>
References: <20140807190243.GA5580@jtriplet-mobl1>
	<20140809001010.GA9437@jtriplet-mobl1>
Date: Fri, 8 Aug 2014 18:22:20 -0700
X-Google-Sender-Auth: jrEW021DTC_yDBKyGkElxo8SRLg
Message-ID: <CA+55aFxaY5q4XhCVgpOBP_dmn+=6JzK+PkX8OHhzZmM7g+NU2g@mail.gmail.com>
Subject: Re: [PATCH v3 2/2] x86: Add "make tinyconfig" to configure the
 tiniest possible kernel
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Josh Triplett <josh@joshtriplett.org>
Cc: Andrew Morton <akpm@linux-foundation.org>, Sam Ravnborg <sam@ravnborg.org>,
        David Rientjes <rientjes@google.com>,
        "Luis R. Rodriguez" <mcgrof@suse.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@redhat.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        "the arch/x86 maintainers" <x86@kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 8, 2014 at 5:10 PM, Josh Triplett <josh@joshtriplett.org> wrote:
> Since commit 5d2acfc7b974bbd3858b4dd3f2cdc6362dd8843a ("kconfig: make
> allnoconfig disable options behind EMBEDDED and EXPERT") in 3.15-rc1,
> "make allnoconfig" disables every possible config option.

May I suggest pushing these through the kbuild tree, rather than
(judging by the people cc'd) the x86 trees?

             Linus
