Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755332AbaFWNOP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Jun 2014 09:14:15 -0400
Received: from mga09.intel.com ([134.134.136.24]:16744 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755311AbaFWNOM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Jun 2014 09:14:12 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,530,1400050800"; 
   d="scan'208";a="532677987"
Message-ID: <1403529246.4686.6.camel@rzhang1-toshiba>
Subject: Re: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
 instead of native resolution
From: Zhang Rui <rui.zhang@intel.com>
To: Martin Kepplinger <martink@posteo.de>
Cc: "rjw@rjwysocki.net" <rjw@rjwysocki.net>,
        "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-media@vger.kernel.org
Date: Mon, 23 Jun 2014 21:14:06 +0800
In-Reply-To: <53A81BF7.3030207@posteo.de>
References: <53A6E72A.9090000@posteo.de>
	 <744357E9AAD1214791ACBA4B0B90926301379B97@SHSMSX101.ccr.corp.intel.com>
	 <53A81BF7.3030207@posteo.de>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2014-06-23 at 14:22 +0200, Martin Kepplinger wrote:
> Am 2014-06-23 03:10, schrieb Zhang, Rui:
> > 
> > 
> >> -----Original Message-----
> >> From: Martin Kepplinger [mailto:martink@posteo.de]
> >> Sent: Sunday, June 22, 2014 10:25 PM
> >> To: Zhang, Rui
> >> Cc: rjw@rjwysocki.net; lenb@kernel.org; linux-acpi@vger.kernel.org;
> >> linux-kernel@vger.kernel.org
> >> Subject: [BUG] rc1 and rc2: Laptop unusable: on boot,screen black
> >> instead of native resolution
> >> Importance: High
> >>
> >> Since 3.16-rc1 my laptop's just goes black while booting, instead of
> >> switching to native screen resolution and showing me the starting
> >> system there. It's an Acer TravelMate B113 with i915 driver and
> >> acer_wmi. It stays black and is unusable.
> >>
This looks like a duplicate of
https://bugzilla.kernel.org/show_bug.cgi?id=78601

thanks,
rui
> >> Do you have other people complain about that? Bisecting didn't lead to
> >> a good result. I could be wrong but I somehow suspect the mistake to be
> >> somewhere in commit 99678ed73a50d2df8b5f3c801e29e9b7a3e5aa85
> >>
> > In order to confirm if the problem is introduced by the above commit,
> > why not checkout the kernel just before and after this commit and see if the problem exists?
> > 
> > Thanks,
> > rui
> > 
> So maybe I was wrong. d27050641e9bc056446deb0814e7ba1aa7911f5a is still
> good and aaeb2554337217dfa4eac2fcc90da7be540b9a73 is the fist bad one.
> This is a big v4l merge. I added the linux-media list in cc now.
> 
> What could be the problem here?
> 
> > 
> >> There is nothing unusual in the kernel log.
> >>
> >> This is quite unusual for an -rc2. Hence my question. I'm happy to test
> >> changes.
> >>
> >>                                      martin
> >> --
> >> Martin Kepplinger
> >> e-mail        martink AT posteo DOT at
> >> chat (XMPP)   martink AT jabber DOT at
> 


