Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933489Ab3GDC16 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 22:27:58 -0400
Received: from mga09.intel.com ([134.134.136.24]:51469 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932206Ab3GDC1z (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 22:27:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,992,1363158000"; 
   d="scan'208";a="364522716"
Date: Thu, 4 Jul 2013 10:27:30 +0800
From: Haicheng Li <haicheng.li@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: linux-kernel@vger.kernel.org, Haicheng Li <haicheng.lee@gmail.com>,
        Len Brown <lenb@kernel.org>, linux-acpi@vger.kernel.org
Subject: Re: [PATCH 3/3] acpi: remove unused LIST_HEAD(acpi_device_list)
Message-ID: <20130704022730.GB3244@hli22-desktop>
References: <1372864578-6925-1-git-send-email-haicheng.li@linux.intel.com>
 <1372864578-6925-3-git-send-email-haicheng.li@linux.intel.com>
 <2729967.3EomeQlnR1@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <2729967.3EomeQlnR1@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jul 03, 2013 at 11:24:03PM +0200, Rafael J. Wysocki wrote:
> On Wednesday, July 03, 2013 11:16:18 PM Haicheng Li wrote:
> > Cc: Len Brown <lenb@kernel.org>
> > Cc: "Rafael J. Wysocki" <rjw@sisk.pl>
> > Cc: linux-acpi@vger.kernel.org
> > Signed-off-by: Haicheng Li <haicheng.li@linux.intel.com>
> 
> -ENOCHANGELOG

Ah, just thought the patch is so trivial a cleanup, should be self-explainable:).

> Apart from this, please send the *whole* patchset to linux-acpi.
Sorry for the confusion. This is actually a standalone patch. I just noticed this
piece of code is not used by acpi anymore and can be removed cleanly.

If needed, I can resend it as a standalone patch.
 
> Thanks,
> Rafael
> 
> 
> > ---
> >  drivers/acpi/scan.c |    1 -
> >  1 file changed, 1 deletion(-)
> > 
> > diff --git a/drivers/acpi/scan.c b/drivers/acpi/scan.c
> > index 27da630..fcc0cdc 100644
> > --- a/drivers/acpi/scan.c
> > +++ b/drivers/acpi/scan.c
> > @@ -29,7 +29,6 @@ extern struct acpi_device *acpi_root;
> >  
> >  static const char *dummy_hid = "device";
> >  
> > -static LIST_HEAD(acpi_device_list);
> >  static LIST_HEAD(acpi_bus_id_list);
> >  static DEFINE_MUTEX(acpi_scan_lock);
> >  static LIST_HEAD(acpi_scan_handlers_list);
> > 
> -- 
> I speak only for myself.
> Rafael J. Wysocki, Intel Open Source Technology Center.
