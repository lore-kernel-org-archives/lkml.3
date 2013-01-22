Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756221Ab3AVXvK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jan 2013 18:51:10 -0500
Received: from mail-pb0-f43.google.com ([209.85.160.43]:48582 "EHLO
	mail-pb0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752474Ab3AVXvG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jan 2013 18:51:06 -0500
Date: Tue, 22 Jan 2013 15:51:01 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: "Rafael J. Wysocki" <rjw@sisk.pl>
Cc: ACPI Devel Maling List <linux-acpi@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>,
        "Kristen C. Accardi" <kristen.c.accardi@intel.com>,
        Len Brown <lenb@kernel.org>
Subject: Re: [PATCH 3/4] sysfs: Functions for adding/removing symlinks
 to/from attribute groups
Message-ID: <20130122235101.GE694@kroah.com>
References: <3307415.pdOY6ovZLa@vostro.rjw.lan>
 <4247313.2G7Z3nCgM0@vostro.rjw.lan>
 <2760421.6nE3tkh92K@vostro.rjw.lan>
 <3401016.osGyQ9N4xP@vostro.rjw.lan>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <3401016.osGyQ9N4xP@vostro.rjw.lan>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 22, 2013 at 03:27:12AM +0100, Rafael J. Wysocki wrote:
> --- linux-pm.orig/include/linux/sysfs.h
> +++ linux-pm/include/linux/sysfs.h
> @@ -154,6 +154,8 @@ int __must_check sysfs_create_bin_file(s
>  void sysfs_remove_bin_file(struct kobject *kobj,
>  			   const struct bin_attribute *attr);
>  
> +int sysfs_create_link_sd(struct sysfs_dirent *sd, struct kobject *target,
> +			 const char *name);

This should go into fs/sysfs/sysfs.h not include/linux/sysfs.h as it's
an "internal" sysfs function.

thanks,

greg k-h
