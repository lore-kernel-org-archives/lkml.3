Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932933AbaBUQsP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:48:15 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:56779 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S932475AbaBUQsO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:48:14 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Toshi Kani <toshi.kani@hp.com>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org
Subject: Re: [PATCH] ACPI: Drop acpi_evaluate_hotplug_ost() and ACPI_HOTPLUG_OST
Date: Fri, 21 Feb 2014 18:03:07 +0100
Message-ID: <4034148.RpCCcq4eis@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.13.0+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1393000318.6784.56.camel@misato.fc.hp.com>
References: <1392789739-32317-1-git-send-email-jiang.liu@linux.intel.com> <5306EB00.1090108@linux.intel.com> <1393000318.6784.56.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, February 21, 2014 09:31:58 AM Toshi Kani wrote:
> On Fri, 2014-02-21 at 13:58 +0800, Jiang Liu wrote:
> > Hi Rafael,
> > 	I failed to get the point to kill ACPI_HOTPLUG_OST altogether:(
> > Should I merge it into my series and resend?
> > 
> > Hi Toshi,
> > 	Any comments here?
> 
> I agree with Rafael and the change looks good to me.  linux/acpi.h
> should also be changed to drop ACPI_HOTPLUG_OST.

That is done by my patch too.

> This define was needed
> originally since we relied on type-specific hotplug notify handlers to
> call _OST.  We now have the ACPI common hotplug handler to take care of
> _OST.
> 
> Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks!

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
