Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756262Ab3AVX5r (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:57:47 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:50886 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751013Ab3AVX5p (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:57:45 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 3/4] sysfs: Functions for adding/removing symlinks to/from attribute groups
Date: Wed, 23 Jan 2013 01:03:46 +0100
Message-ID: <1484484.nWT31vvEGO@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc4; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130122235101.GE694@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan> <3401016.osGyQ9N4xP@vostro.rjw.lan> <20130122235101.GE694@kroah.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tuesday, January 22, 2013 03:51:01 PM Greg Kroah-Hartman wrote:
> On Tue, Jan 22, 2013 at 03:27:12AM +0100, Rafael J. Wysocki wrote:
> > --- linux-pm.orig/include/linux/sysfs.h
> > +++ linux-pm/include/linux/sysfs.h
> > @@ -154,6 +154,8 @@ int __must_check sysfs_create_bin_file(s
> >  void sysfs_remove_bin_file(struct kobject *kobj,
> >  			   const struct bin_attribute *attr);
> >  
> > +int sysfs_create_link_sd(struct sysfs_dirent *sd, struct kobject *target,
> > +			 const char *name);
> 
> This should go into fs/sysfs/sysfs.h not include/linux/sysfs.h as it's
> an "internal" sysfs function.

Damn, right.  Will fix.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
