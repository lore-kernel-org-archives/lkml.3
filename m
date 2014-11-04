Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751738AbaKDVI1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 16:08:27 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:49556 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751129AbaKDVIZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 16:08:25 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grant Likely <grant.likely@linaro.org>
Cc: Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnd Bergmann <arnd@arndb.de>,
        ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Darren Hart <darren.hart@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Bryan Wu <cooloney@gmail.com>
Subject: Re: [PATCH v6 02/12] Driver core: Unified device properties interface for platform firmware
Date: Tue, 04 Nov 2014 22:29:08 +0100
Message-ID: <3275773.HN9MNfIOOq@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CACxGe6uv0TmoZivL3ESw+oRW-OjqakLP4KBnDrwJXzQ2ku8ZLA@mail.gmail.com>
References: <13750506.S2yVlRRDa2@vostro.rjw.lan> <3645687.BsyGDrJDrU@vostro.rjw.lan> <CACxGe6uv0TmoZivL3ESw+oRW-OjqakLP4KBnDrwJXzQ2ku8ZLA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, November 04, 2014 05:01:04 PM Grant Likely wrote:
> On Mon, Nov 3, 2014 at 10:04 PM, Rafael J. Wysocki <rjw@rjwysocki.net> wrote:
> >> I also found that this parser code doesn't correctly handle malformed
> >> (unterminated) string properties. It will overflow. The existing
> >> functions have the same problem, so it isn't something that you've
> >> added. I've got a fix, and as a side effect the fix creates the _array
> >> version basically for free as part of reworking
> >> of_property_count_strings() and of_property_read_string_index()
> >
> > OK
> >
> > So can you please point me to a git branch containing the fix?  I'll rebase the
> > patch on top of that then and everything should merge just fine.
> 
> git://git.kernel.org/pub/scm/linux/kernel/git/glikely/linux.git devicetree/merge
> 
> I'm going to let the patch sit in there for a few days to get
> linux-next exposure before I ask Linus to pull. The pull req will go
> out before the end of the week.

OK, thanks!

Pulled, rebased my device-properties branch, merged into linux-pm.git/linux-next
and pushed back.

Rafael

