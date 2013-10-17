Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762676Ab3JQUUu (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Oct 2013 16:20:50 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762649Ab3JQUUs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Oct 2013 16:20:48 -0400
Date: Thu, 17 Oct 2013 13:20:47 -0700
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Rob Herring <robherring2@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Rob Herring <rob.herring@calxeda.com>,
        Paolo Pisati <paolo.pisati@canonical.com>,
        Tim Gardner <tim.gardner@canonical.com>, Jiri Slaby <jslaby@suse.cz>
Subject: Re: [PATCH v2] TTY: hvc_dcc: probe for a JTAG connection before
 registering
Message-ID: <20131017202047.GA24568@kroah.com>
References: <1379968234-23373-1-git-send-email-robherring2@gmail.com>
 <1380074758-19808-1-git-send-email-robherring2@gmail.com>
 <CAL_JsqK0hPtoD22fw3J+TmgNwJeJUYwjB9i1C4n817GvuOxQxw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAL_JsqK0hPtoD22fw3J+TmgNwJeJUYwjB9i1C4n817GvuOxQxw@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Oct 17, 2013 at 02:16:37PM -0500, Rob Herring wrote:
> On Tue, Sep 24, 2013 at 9:05 PM, Rob Herring <robherring2@gmail.com> wrote:
> > From: Rob Herring <rob.herring@calxeda.com>
> >
> > Enabling the ARM DCC console and using without a JTAG connection will
> > simply hang the system. Since distros like to turn on all options, this
> > is a reoccurring problem to debug. We can do better by checking if
> > anything is attached and handling characters. There is no way to probe
> > this, so send a newline and check that it is handled.
> >
> > Cc: Paolo Pisati <paolo.pisati@canonical.com>
> > Cc: Tim Gardner <tim.gardner@canonical.com>
> > Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> > Cc: Jiri Slaby <jslaby@suse.cz>
> > Signed-off-by: Rob Herring <rob.herring@calxeda.com>
> > ---
> > v2: use time_is_after_jiffies
> >
> >  drivers/tty/hvc/hvc_dcc.c | 21 +++++++++++++++++++++
> >  1 file changed, 21 insertions(+)
> 
> Greg, Jiri,
> 
> Can you please apply.

I already did, didn't you get an email saying it was applied to my tree?

