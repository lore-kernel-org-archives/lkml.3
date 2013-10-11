Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755869Ab3JKAT2 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 20:19:28 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:38020 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1755427Ab3JKATN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 20:19:13 -0400
Date: Thu, 10 Oct 2013 20:19:09 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Message-ID: <20131010201909.5d83cf36@gandalf.local.home>
In-Reply-To: <CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
References: <20131010165905.7815defa@gandalf.local.home>
	<CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
	<81272921.7ZJW2CaxNE@vostro.rjw.lan>
	<CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.130:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 14:37:15 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> On Thu, Oct 10, 2013 at 2:35 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >
> > Well, I must have overlooked the original report.  Is it available anywhere
> > I can find it?
> 
> I think Steven has some buggered email system, he has other emails
> being eaten by lkml too, and apparently other mail gateways (because
> you were direct-cc'd on the original).
> 
> His email sender doesn't quote names with "," in them, and has headers

I think the issue is with "." not ","

> like this:
> 
>   From: Steven Rostedt <rostedt@goodmis.org>
>   To: LKML <linux-kernel@vger.kernel.org>
>   Cc: Linus Torvalds <torvalds@linux-foundation.org>, Rafael J. Wysocki

This may have been my fault, as I cut and pasted Rafael's email from
the git log, and did not add the quotes myself.

Perhaps claws should force names with '.' to be quoted. I don't
remember having this issue with Evolution (I switched to claws a couple
of months ago).


>    <rafael.j.wysocki@intel.com>, Mika Westerberg
>    <mika.westerberg@linux.intel.com>, Bjorn Helgaas <bhelgaas@google.com>,
>    Andrew Morton <akpm@linux-foundation.org>
> 
> which is apparently against SMTP rules. The magic line is:
> 
>   X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
> 
> The tag-line for that mailer is quite appropriate: "The email reader
> that bites". That's what they put in the title on their web-page.
> 
> Because it sure bites. Except the claws people seemed to think that
> was supposed to be a good thing. They clearly don't know the slang
> meaning of "that bites".
> 
> Or maybe they do, and they are just unusually self-aware.
> 
> Steven, I'd suggest just jettisoning that mailer.

The first time it was from the address book, as when I added it from an
email, claws stripped out the quotes when it added it. This time it was
just me cut and pasting a name with a '.' without adding quotes myself.

-- Steve

