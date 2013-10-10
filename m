Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756322Ab3JJVhS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:37:18 -0400
Received: from mail-vb0-f51.google.com ([209.85.212.51]:38260 "EHLO
	mail-vb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752293Ab3JJVhQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:37:16 -0400
MIME-Version: 1.0
In-Reply-To: <81272921.7ZJW2CaxNE@vostro.rjw.lan>
References: <20131010165905.7815defa@gandalf.local.home>
	<CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
	<81272921.7ZJW2CaxNE@vostro.rjw.lan>
Date: Thu, 10 Oct 2013 14:37:15 -0700
X-Google-Sender-Auth: bHO1GH73cryX-vn0yvo-kn4RCAQ
Message-ID: <CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
From: Linus Torvalds <torvalds@linux-foundation.org>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Steven Rostedt <rostedt@goodmis.org>, LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 2:35 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
>
> Well, I must have overlooked the original report.  Is it available anywhere
> I can find it?

I think Steven has some buggered email system, he has other emails
being eaten by lkml too, and apparently other mail gateways (because
you were direct-cc'd on the original).

His email sender doesn't quote names with "," in them, and has headers
like this:

  From: Steven Rostedt <rostedt@goodmis.org>
  To: LKML <linux-kernel@vger.kernel.org>
  Cc: Linus Torvalds <torvalds@linux-foundation.org>, Rafael J. Wysocki
   <rafael.j.wysocki@intel.com>, Mika Westerberg
   <mika.westerberg@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
   Andrew Morton <akpm@linux-foundation.org>

which is apparently against SMTP rules. The magic line is:

  X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)

The tag-line for that mailer is quite appropriate: "The email reader
that bites". That's what they put in the title on their web-page.

Because it sure bites. Except the claws people seemed to think that
was supposed to be a good thing. They clearly don't know the slang
meaning of "that bites".

Or maybe they do, and they are just unusually self-aware.

Steven, I'd suggest just jettisoning that mailer.

                   Linus
