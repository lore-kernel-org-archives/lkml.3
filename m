Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934435Ab3GWXzs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 19:55:48 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:36637 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934085Ab3GWXzr (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 19:55:47 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Kamal Mostafa <kamal@canonical.com>, James Hogan <james@albanarts.com>,
        Steven Newbury <steve@snewbury.org.uk>,
        Martin Steigerwald <Martin@lichtvoll.de>,
        =?ISO-8859-1?Q?J=F6rg?= Otte <jrg.otte@gmail.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Subject: Re: Linux 3.11-rc2 (acpi backlight)
Date: Wed, 24 Jul 2013 02:05:48 +0200
Message-ID: <1657635.t6GA9ja9Ss@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.10.0+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <1374605189.31029.25.camel@fourier>
References: <CA+55aFy330bSRjK5HT1n0wXioPykL3RquHXyBPjm5GpTz_Y=DQ@mail.gmail.com> <9012759.Alzqtdvh5b@vostro.rjw.lan> <1374605189.31029.25.camel@fourier>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, July 23, 2013 11:46:29 AM Kamal Mostafa wrote:
> On Mon, 2013-07-22 at 21:54 +0200, Rafael J. Wysocki wrote:
> > On Monday, July 22, 2013 11:11:54 AM Linus Torvalds wrote:
> > > On Mon, Jul 22, 2013 at 6:02 AM, Rafael J. Wysocki <rjw@sisk.pl> wrote:
> > > >
> > > > Linus, do you want me to send a pull request reverting 8c5bd7a and efaa14c?
> > > 
> > > Yes, but [...] I'd suggest doing the revert just in time for
> > > rc3, but waiting until then to gather info about people who see
> > > breakage.
> > > 
> > > Sound like a plan?
> > 
> > Yes, it does.
> > 
> > Rafael
> 
> 
> Hi Rafael-
> 
> For your reference...
> 
> As James Hogan reported, those ACPI changes break backlight control on
> the "Dell XPS13" Ivy Bridge models (the Sandy Bridge XPS13 model is not
> affected).
> 
> I confirm that reverting 8c5bd7a and efaa14c fixes it again.

Thanks!

I'd like to collect some information on the systems having problems with those
two commits (to see if they are similar somehow).

It seems that one common symptom is that brightness cannot be controlled
through function keys.  Is that correct for all of you?  If so, did you try
any other way to control brightness, like a GUI-based?

Also, can you all please send me (a) the output of dmidecode and (b) the
contents of /proc/cpuinfo from your systems?

Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
