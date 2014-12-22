Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754966AbaLVTLw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 22 Dec 2014 14:11:52 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36702 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754786AbaLVTLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 22 Dec 2014 14:11:51 -0500
Date: Mon, 22 Dec 2014 11:11:50 -0800
From: Greg KH <gregkh@linuxfoundation.org>
To: Simone Weiss <simone.weiss@fau.de>
Cc: devel@driverdev.osuosl.org, linux-kernel@i4.cs.fau.de,
        lidza.louina@gmail.com, driverdev-devel@linuxdriverproject.org,
        helene.gsaenger@studium.fau.de, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [PATCH v2 2/6] dgnc/dgnc_sysfs.c: checkpatch: Use of
 dev_err ? instead of printk
Message-ID: <20141222191150.GA26768@kroah.com>
References: <20141222020039.GA2489@kroah.com>
 <1419273836-11192-1-git-send-email-simone.weiss@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1419273836-11192-1-git-send-email-simone.weiss@fau.de>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Dec 22, 2014 at 07:43:56PM +0100, Simone Weiss wrote:
> I originally wanted to replace both of  the  printk cals in this file with dev_err().
> But in the function dgnc_create_driver_sysfiles only the struct pci_driver was given,
> sadly I coudn't figure out a way to get a struct device when only a struct pci_driver is given.

There should not be any driver-specific sysfs files, if so, something is
wrong here...

