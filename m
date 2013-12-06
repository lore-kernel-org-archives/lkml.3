Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753060Ab3LFBre (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 20:47:34 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:61191 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751257Ab3LFBrb convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 20:47:31 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: Andy Shevchenko <andriy.shevchenko@linux.intel.com>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] SFI: fix compilation warnings
Date: Fri, 06 Dec 2013 03:00:31 +0100
Message-ID: <1790293.cpW4sKD6m8@vostro.rjw.lan>
User-Agent: KMail/4.10.5 (Linux/3.12.0-rc6+; KDE/4.10.5; x86_64; ; )
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E8802494B65@SHSMSX101.ccr.corp.intel.com>
References: <1386264397-27319-1-git-send-email-andriy.shevchenko@linux.intel.com> <1419818.3DzaCCe02K@vostro.rjw.lan> <1AE640813FDE7649BE1B193DEA596E8802494B65@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 8BIT
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, December 06, 2013 01:26:07 AM Zheng, Lv wrote:
> > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > Sent: Friday, December 06, 2013 9:26 AM
> > 
> > On Friday, December 06, 2013 01:08:45 AM Zheng, Lv wrote:
> > > > From: Rafael J. Wysocki [mailto:rjw@rjwysocki.net]
> > > > Sent: Friday, December 06, 2013 6:37 AM
> > > >
> > > > On Thursday, December 05, 2013 07:26:37 PM Andy Shevchenko wrote:
> > > > > When build kernel with make W=1 we get the following compiler error.
> > > > >
> > > > > In file included from drivers/sfi/sfi_acpi.c:66:0:
> > > > > include/linux/sfi_acpi.h: In function ‘acpi_sfi_table_parse’:
> > > > > include/linux/sfi_acpi.h:72:2: error: implicit declaration of function ‘acpi_table_parse’ [-Werror=implicit-function-declaration]
> > > > >   if (!acpi_table_parse(signature, handler))
> > > > >   ^
> > > > >   cc1: some warnings being treated as errors
> > > > >
> > > > > The patch changes acpi/acpi.h inclusion to linux/acpi.h.
> > > > >
> > > > > Signed-off-by: Andy Shevchenko <andriy.shevchenko@linux.intel.com>
> > > >
> > > > OK
> > > >
> > > > Lv, I'm dropping your patch cleaning up the inclusions, please sort that thing
> > > > out entirely for the next cycle.
> > >
> > > No, I think Andy's patch is wrong.
> > 
> > His patch may be wrong, but the warning in his changelog surely is real. :-)
> > 
> > > This warning is existing before merging my fixes.
> > >
> > > Either we fix this warning or leave it as is.
> > >
> > > To fix it, you need to add 1 line in sfi_acpi.h rather than change the line.
> > > Let me post a fix for this.
> > 
> > Please do.  And I'm putting all ACPI header cleanups on hold until all warnings
> > of this kind have been fixed by them.  Otherwise doing those cleanups makes a
> > little sense in my opinion.
> 
> OK, not only this warning, there is another warning in sfi_acpi.c.
> I doubt whether they are strictly tested before upstreamed...
> They are all existing warnings.
> You can apply my new patch before the cleanup series.

Sorry, I'm already lost in the thick of patches. :-)

Please resend them all as a single series.

Thanks,
Rafael

