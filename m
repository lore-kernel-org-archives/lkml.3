Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753993AbaF0POr (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 11:14:47 -0400
Received: from mga02.intel.com ([134.134.136.20]:20025 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752740AbaF0POq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 11:14:46 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,560,1400050800"; 
   d="scan'208";a="535101650"
Message-ID: <1403882067.16305.124.camel@rzhang1-toshiba>
Subject: Re: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
 instead of native resolution
From: Zhang Rui <rui.zhang@intel.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Date: Fri, 27 Jun 2014 23:14:27 +0800
In-Reply-To: <53A83DC7.1010606@posteo.de>
References: <53A6E72A.9090000@posteo.de>
		 <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>
		 <53A81BF7.3030207@posteo.de> <1403529246.4686.6.camel@rzhang1-toshiba>
	 <53A83DC7.1010606@posteo.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 16:46 +0200, Martin Kepplinger wrote:
> Am 2014-06-23 15:14, schrieb Zhang Rui:
> > On Mon, 2014-06-23 at 14:22 +0200, Martin Kepplinger wrote:
> >> Am 2014-06-23 03:10, schrieb Zhang, Rui:
> >>>
> >>>
> >>>> -----Original Message-----
> >>>> From: Martin Kepplinger [mailto:martink@posteo.de]
> >>>> Sent: Sunday, June 22, 2014 10:25 PM
> >>>> To: Zhang, Rui
> >>>> Cc: rjw@rjwysocki.net; lenb@kernel.org; linux-acpi@vger.kernel.org;
> >>>> linux-kernel@vger.kernel.org
> >>>> Subject: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
> >>>> instead of native resolution
> >>>> Importance: High
> >>>>
> >>>> Since 3.16-rc1 my laptop's just goes black while booting, instead of
> >>>> switching to native screen resolution and showing me the starting
> >>>> system there. It's an Acer TravelMate B113 with i915 driver and
> >>>> acer_wmi. It stays black and is unusable.
> >>>>
> > This looks like a duplicate of
> > https://bugzilla.kernel.org/show_bug.cgi?id=78601
> > 
> > thanks,
> > rui
> I'm not sure about that. I have no problem with v3.15 and the screen
> goes black way before a display manager is started. It's right after the
> kernel loaded and usually the screen is set to native resolution.
> 
> Bisect told me aaeb2554337217dfa4eac2fcc90da7be540b9a73 as the first bad
> one. Although, checking that out and running it, works good. not sure if
> that makes sense.
> 
could you please check if the comment in
https://bugzilla.kernel.org/show_bug.cgi?id=78601#c5 solves your problem
or not?

thanks,
rui
> >>>> Do you have other people complain about that? Bisecting didn't lead to
> >>>> a good result. I could be wrong but I somehow suspect the mistake to be
> >>>> somewhere in commit 99678ed73a50d2df8b5f3c801e29e9b7a3e5aa85
> >>>>
> >>> In order to confirm if the problem is introduced by the above commit,
> >>> why not checkout the kernel just before and after this commit and see if the problem exists?
> >>>
> >>> Thanks,
> >>> rui
> >>>
> >> So maybe I was wrong. d27050641e9bc056446deb0814e7ba1aa7911f5a is still
> >> good and aaeb2554337217dfa4eac2fcc90da7be540b9a73 is the fist bad one.
> >> This is a big v4l merge. I added the linux-media list in cc now.
> >>
> >> What could be the problem here?
> >>
> >>>
> >>>> There is nothing unusual in the kernel log.
> >>>>
> >>>> This is quite unusual for an -rc2. Hence my question. I'm happy to test
> >>>> changes.
> >>>>
> >>>>                                      martin
> >>>> --
> >>>> Martin Kepplinger
> >>>> e-mail        martink AT posteo DOT at
> >>>> chat (XMPP)   martink AT jabber DOT at
> >>
> > 
> > 
> 


