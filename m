Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755648Ab3AKVxQ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 16:53:16 -0500
Received: from hydra.sisk.pl ([212.160.235.94]:38187 "EHLO hydra.sisk.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754799Ab3AKVxP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 16:53:15 -0500
From: "Rafael J. Wysocki" <rjw@sisk.pl>
To: ACPI Devel Maling List <linux-acpi@vger.kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Len Brown <lenb@kernel.org>,
        Lv Zheng <lv.zheng@intel.com>, Huang Ying <ying.huang@intel.com>
Subject: Re: [PATCH 0/6] ACPI / PM: ACPI power management update
Date: Fri, 11 Jan 2013 22:59:02 +0100
Message-ID: <1522746.siPuD1toxr@vostro.rjw.lan>
User-Agent: KMail/4.9.5 (Linux/3.8.0-rc3+; KDE/4.9.5; x86_64; ; )
In-Reply-To: <2311196.icSMDvAsYg@vostro.rjw.lan>
References: <2311196.icSMDvAsYg@vostro.rjw.lan>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Friday, January 04, 2013 10:58:41 PM Rafael J. Wysocki wrote:
> Hi All,
> 
> There are a few changes of the ACPI power management code I've gathered
> over the last few weeks.  Some of them are just cleanups etc., but some
> fix (potential) problems and/or add new functionality.
> 
> [1/6] - Rework power states changing so that we put devices into D3hot
>         (if available) before removing power from them entirely.
> [2/6] - Rename __acpi_bus_get_power() (for future use).
> [3/6] - Rename state_string() (in bus.c, for future use).
> [4/6] - Export the (current) power states of ACPI devices via sysfs.
> [5/6] - Move device power management functions from bus.c to device_pm.c.
> [6/6] - (Unrelated to the above) Get rid of some ugly #ifdefs in sleep.c.
> 
> All of them except for [1/6] have been posted already and no one has had any
> comments.
> 
> Please review.

OK, I don't see any objections, so I'm taking it into linux-next for v3.9.

Thanks,
Rafael


-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
