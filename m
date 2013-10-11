Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755995Ab3JKOIa (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Oct 2013 10:08:30 -0400
Received: from tex.lwn.net ([70.33.254.29]:42173 "EHLO vena.lwn.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751735Ab3JKOI2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Oct 2013 10:08:28 -0400
Date: Fri, 11 Oct 2013 08:08:27 -0600
From: Jonathan Corbet <corbet@lwn.net>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
Message-ID: <20131011080827.6deb2bf6@lwn.net>
In-Reply-To: <CA+55aFyDiF43Oawdsb6EPhsdrLZS_L3PCj5fRJsEqRAnVW8Jgg@mail.gmail.com>
References: <20131010165905.7815defa@gandalf.local.home>
	<CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
	<81272921.7ZJW2CaxNE@vostro.rjw.lan>
	<CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
	<20131010201909.5d83cf36@gandalf.local.home>
	<CA+55aFyDiF43Oawdsb6EPhsdrLZS_L3PCj5fRJsEqRAnVW8Jgg@mail.gmail.com>
Organization: LWN.net
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Oct 2013 18:00:48 -0700
Linus Torvalds <torvalds@linux-foundation.org> wrote:

> File a bug on Claws, and if the developers brush it off as your own
> problem, just stop using the PoS.

They acknowledge the bug - it was already known to them, actually.  With
luck we'll see a fix soon.

jon
