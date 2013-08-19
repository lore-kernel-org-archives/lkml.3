Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751737Ab3HSXUN (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 19:20:13 -0400
Received: from hydra.sisk.pl ([212.160.235.94]:50401 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750816Ab3HSXUM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 19:20:12 -0400
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: Mika Westerberg <mika.westerberg@linux.intel.com>
Cc: Jerry Snitselaar <jerry.snitselaar@oracle.com>,
        linux-kernel@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: Re: [PATCH] acpi_i2c: set MODULE_LICENSE, MODULE_AUTHOR, and MODULE_DESCRIPTION
Date: Tue, 20 Aug 2013 01:30:45 +0200
Message-ID: <2870377.GVGv4QBgQK@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.11.0-rc5+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <20130819061614.GG4898@intel.com>
References: <1376702795-25912-1-git-send-email-jerry.snitselaar@oracle.com> <20130819061614.GG4898@intel.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Monday, August 19, 2013 09:16:14 AM Mika Westerberg wrote:
> On Fri, Aug 16, 2013 at 06:26:35PM -0700, Jerry Snitselaar wrote:
> > Without MODULE_LICENSE set, I get the following with modprobe:
> > 
> > acpi_i2c: module license 'unspecified' taints kernel.
> > acpi_i2c: Unknown symbol i2c_new_device (err 0)
> > acpi_i2c: Unknown symbol acpi_dev_get_resources (err 0)
> > acpi_i2c: Unknown symbol acpi_dev_resource_interrupt (err 0)
> > acpi_i2c: Unknown symbol acpi_dev_free_resource_list (err 0)
> > 
> > Signed-off-by: Jerry Snitselaar <jerry.snitselaar@oracle.com>
> 
> Looks good to me.
> 
> Acked-by: Mika Westerbeg <mika.westerberg@linux.intel.com>

Well, OK, but do we need to be able to build that as a module?

Maybe it should just be yes or no?

Rafael

