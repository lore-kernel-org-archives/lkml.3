Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933281AbaCQNJL (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 09:09:11 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:51583 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S933001AbaCQNJJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 09:09:09 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        linux-kernel@vger.kernel.org
Subject: Re: v3.14-rc1+: new error: "nsc-ircc, Wrong chip version ff"
Date: Mon, 17 Mar 2014 14:24:36 +0100
Message-ID: <3479041.IcXy3De7AH@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.14.0-rc6+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1395059613.1999.7.camel@x41>
References: <1395006095.2002.8.camel@x41> <3120107.Slm5jUkmCN@vostro.rjw.lan> <1395059613.1999.7.camel@x41>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, March 17, 2014 01:33:33 PM Paul Bolle wrote:
> Rafael J. Wysocki schreef op ma 17-03-2014 om 01:02 [+0100]:
> > On Sunday, March 16, 2014 10:41:35 PM Paul Bolle wrote:
> > > 2) What should I do to make that error go away?
> > 
> > This is not an error, but a message whose log level is too high.  It basically
> > means "I found something, but I don't like it, so I'm not going to handle it."
> 
> I see. It's actually quite old and is mentioned rather often on the web.
> I must have seen if before, when I actually used IrDA, but that's a few
> years ago now.

I see.

> > The messages come from nsc_ircc_setup(), which is called from nsc_ircc_open(),
> > which in turn is called by nsc_ircc_init(), which is a module intialization
> > function of the nsc-ircc module.
> > 
> > I *guess* what happens is that the PNP layer creates a PNP device object
> > for something it didn't create an object for previously, so I wonder if the
> > patch below makes those messages go away?
> 
> No, they're still there (with this patch applied on top of v3.14-rc7).

Beats me then.

I'm sure it can be tracked down, but I'm not sure it's worth spending the time.

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
