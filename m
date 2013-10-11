Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754810Ab3JKBAw (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Oct 2013 21:00:52 -0400
Received: from mail-vc0-f182.google.com ([209.85.220.182]:33316 "EHLO
	mail-vc0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752264Ab3JKBAv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Oct 2013 21:00:51 -0400
MIME-Version: 1.0
In-Reply-To: <20131010201909.5d83cf36@gandalf.local.home>
References: <20131010165905.7815defa@gandalf.local.home>
	<CA+55aFxTwBoeQOimg-ut+BipWx2veNOPT0yGvFBFn7nbX5yCkg@mail.gmail.com>
	<81272921.7ZJW2CaxNE@vostro.rjw.lan>
	<CA+55aFwA8WZ+ARtNFFY+z4d8kS5AUBLg32iu7Jkk3rsz_i1OZw@mail.gmail.com>
	<20131010201909.5d83cf36@gandalf.local.home>
Date: Thu, 10 Oct 2013 18:00:48 -0700
X-Google-Sender-Auth: T_1Hrvl_hF1eckB9Rad47sCBEnE
Message-ID: <CA+55aFyDiF43Oawdsb6EPhsdrLZS_L3PCj5fRJsEqRAnVW8Jgg@mail.gmail.com>
Subject: Re: [BUG] WARN_ON(!context) in drivers/pci/hotplug/acpiphp_glue.c
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
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

On Thu, Oct 10, 2013 at 5:19 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
>
> This may have been my fault, as I cut and pasted Rafael's email from
> the git log, and did not add the quotes myself.

Well, it is your fault, but only because you use a buggy mailer from hell.

> Perhaps claws should force names with '.' to be quoted. I don't
> remember having this issue with Evolution (I switched to claws a couple
> of months ago).

There is no "perhaps" about this. It's clearly a Claws bug.

When you send email to Amaury Decrême (to pick a kernel email address
at random with special characters) do you think you should write his
email address as

  =?UTF-8?q?Amaury=20Decr=C3=AAme?= <amaury.decreme@gmail.com>?

No you should not. For similar reasons, any email program that expects
you to quote dots in names is pure and utter garbage. The fact that
SMTP expects dots to be quoted has absolutely zero bearing on
anything, the same way it has zero bearing that SMTP headers should
use even odder quoting rules for other "special" characters.

File a bug on Claws, and if the developers brush it off as your own
problem, just stop using the PoS.

I realize that you seem to have this self-harming habit - first
evolution, now claws - but it's like cutting or anorexia. We're having
an intervention here, and the first step is to realize you have a
problem.

                  Linus
