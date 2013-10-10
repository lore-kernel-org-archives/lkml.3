Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757549Ab3JJVYM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 17:24:12 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:62335 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1756176Ab3JJVYK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 17:24:10 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Linus Torvalds <torvalds@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Date: Thu, 10 Oct 2013 23:35:53 +0200
Message-ID: <81272921.7ZJW2CaxNE@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.11.0+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
References: <20131010165905.7815defa@gandalf.local.home> <CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, October 10, 2013 02:17:58 PM Linus Torvalds wrote:
> On Thu, Oct 10, 2013 at 1:59 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > Unfortunately it's not a single commit. I tried to bisect it better,
> > but it really is the merge. I'm thinking a chance in one merge caused
> > the WARN_ON() to trigger that was added in a later merge.

Well, I must have overlooked the original report.  Is it available anywhere
I can find it?

Rafael

