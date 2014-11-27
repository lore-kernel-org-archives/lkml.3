Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751283AbaK0QpW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 11:45:22 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:59051 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1750861AbaK0QpT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 11:45:19 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Ken Xue <Ken.Xue@amd.com>, "lenb@kernel.org" <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wu, Jeff" <Jeff.Wu@amd.com>,
        Andriy Shevchenko <andriy.shevchenko@intel.com>
Subject: Re: [PATCH] acpi:apd:add AMD ACPI2Platform device support for x86 system.
Date: Thu, 27 Nov 2014 18:06:35 +0100
Message-ID: <2448167.LI9SjY8OTa@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <20141127114637.GA1304@lahna.fi.intel.com>
References: <1416290291-5802-1-git-send-email-Ken.Xue@amd.com> <1416997898.17328.5.camel@kxue-X58A-UD3R> <20141127114637.GA1304@lahna.fi.intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday, November 27, 2014 01:46:37 PM Mika Westerberg wrote:
> On Wed, Nov 26, 2014 at 06:31:38PM +0800, Ken Xue wrote:

[cut]

> > diff --git a/drivers/acpi/acpi_soc.h b/drivers/acpi/acpi_soc.h
> > new file mode 100755
> > index 0000000..96db30e
> > --- /dev/null
> > +++ b/drivers/acpi/acpi_soc.h
> 
> And all this belongs to drivers/acpi/internal.h.

I requested the new file.

I don't really want things specific to SoC drivers to be mixed up with ACPI core
stuff.  It may even be good to create a separate subdir for the SoC stuff, but
that can be done later.


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
