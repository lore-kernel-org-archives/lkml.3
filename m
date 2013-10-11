Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754968Ab3JKBHV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:07:21 -0400
Received: from mail-vb0-f41.google.com ([209.85.212.41]:47690 "EHLO
	mail-vb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750983Ab3JKBHU convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:07:20 -0400
MIME-Version: 1.0
In-Reply-To: <1381453575.14017.26.camel@joe-AO722>
References: <20131010165905.7815defa@gandalf.local.home>
	<CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
	<81272921.7ZJW2CaxNE@vostro.rjw.lan>
	<CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
	<20131010201909.5d83cf36@gandalf.local.home>
	<CA+55aFyDiF43Oawdsb6EPhsdrLZS_L3PCj5fRJsEqRAnVW8Jgg@mail.gmail.com>
	<1381453575.14017.26.camel@joe-AO722>
Date: Thu, 10 Oct 2013 18:07:18 -0700
X-Google-Sender-Auth: wv-VDQZnQmBpbQHRcMIrxEJbn1Y
Message-ID: <CA+55aFxTYX7Or11487ydC29utO4qjchkLKcvHMoCTNeFmRf-3A@mail.gmail.com>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Joe Perches <joe@perches.com>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        LKML <linux-kernel@vger.kernel.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Andrew Morton <akpm@linux-foundation.org>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 10, 2013 at 6:06 PM, Joe Perches <joe@perches.com> wrote:
> On Thu, 2013-10-10 at 18:00 -0700, Linus Torvalds wrote:
>> the first step is to realize you have a problem.
>
> Says the guy that can only send patches to the list
> as attachments not plain text because he uses gmail.

Yeah. I fire up pine every once in a while if I have more than one
patch to send, but touché.

           Linus
