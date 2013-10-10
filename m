Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756214Ab3JJWbR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 18:31:17 -0400
Received: from tex.lwn.net ([70.33.254.29]:38541 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751712Ab3JJWbQ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 18:31:16 -0400
Date: Thu, 10 Oct 2013 16:31:14 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Steven Rostedt <rostedt@goodmis.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: Claws (was [BUG] WARN_ON(!context) in
 drivers/pci/hotplug/acpiphp_glue.c)
Message-ID: <20131010163114.7103657d@lwn.net>
In-Reply-To: <CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
References: <20131010165905.7815defa@gandalf.local.home>
	<CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
	<81272921.7ZJW2CaxNE@vostro.rjw.lan>
	<CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 14:37:15 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> Steven, I'd suggest just jettisoning that mailer.

FWIW, I've used claws for years and never run into an issue like that.
This email comes from claws; the quoting looks right in the compose window
now, I assume it will go out in good form.  Otherwise I'll have just made
a fool of myself in front of everybody, but, then, that's what I do for a
living, so that's OK too.

The problem, from what Steve said before, had to do with the address
book.  I assume there's a real bug there...I bet we could get it fixed.
They've taken patches from me without grief, and are generally responsive
to this sort of thing.  I'll forward things over to the claws list and see
what they say.

jon
