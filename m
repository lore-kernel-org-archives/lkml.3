Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751757AbaKEVyl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 16:54:41 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:62215 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751333AbaKEVyk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 16:54:40 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@secretlab.ca>
Cc: Timur Tabi <timur@codeaurora.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Mathias Nyman <mathias.nyman@linux.intel.com>,
        Ning Li <ning.li@intel.com>, Alan Cox <alan@linux.intel.com>,
        lkml <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH v2 0/2] pinctrl: Intel Cherryview/Braswell support
Date: Wed, 05 Nov 2014 23:15:26 +0100
Message-ID: <1632312.tiWezf5I7W@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACxGe6t=nK83pGNDKmZJ28BZJqgNjGZgckrzVrBiFko1AcT0xg@mail.gmail.com>
References: <1415012493-134561-1-git-send-email-mika.westerberg@linux.intel.com> <545912D2.5090708@codeaurora.org> <CACxGe6t=nK83pGNDKmZJ28BZJqgNjGZgckrzVrBiFko1AcT0xg@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 05, 2014 09:46:14 PM Grant Likely wrote:
> On Tue, Nov 4, 2014 at 5:54 PM, Timur Tabi <timur@codeaurora.org> wrote:
> > On 11/04/2014 02:20 AM, Mika Westerberg wrote:
> >>
> >> There is nothing like that yet in ACPI world but with the ACPI _DSD
> >> patches we are getting properties similar to DT which means that we can
> >> provide pinctrl bindings from ACPI systems as well.
> >
> >
> > Do you know if anyone has signed up to actually do the work of defining how
> > pinctrl will look in ACPI?  I'm guessing the simplest approach would be to:
> 
> Actually, for the most part we /don't/ want to try and put pinctrl
> into an ACPI binding. The assumption is that on an ACPI platform it
> would be the combination of ACPI and firmware responsible for the pin
> mappings, not the operating system.
> 
> Before even attempting to put pinctrl mappings into your driver, there
> should instead be a conversation at the ACPI spec level about whether
> or not it makes sense and what such a binding should look like.

We may need to support pinctrl on ACPI platforms in the meantime, though,
for reasons that Mika mentioned at one point (there are systems where the
firmware mangles things etc., which quite frankly is to be expected).

So while I'm all for discussing this in the ASWG, what's the interim approach
we should be using, in your opinion?

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
