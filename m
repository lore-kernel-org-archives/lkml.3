Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932981AbaBUQjH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 21 Feb 2014 11:39:07 -0500
Received: from g2t1383g.austin.hp.com ([15.217.136.92]:42367 "EHLO
	g2t1383g.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932544AbaBUQjE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 21 Feb 2014 11:39:04 -0500
Message-ID: <1393000318.6784.56.camel@misato.fc.hp.com>
Subject: Re: [PATCH] ACPI: Drop acpi_evaluate_hotplug_ost() and
 ACPI_HOTPLUG_OST
From: Toshi Kani <toshi.kani@hp.com>
To: Jiang Liu <jiang.liu@linux.intel.com>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        "Rafael J . Wysocki" <rafael.j.wysocki@intel.com>,
        Lv Zheng <lv.zheng@intel.com>, Len Brown <lenb@kernel.org>,
        Robert Moore <robert.moore@intel.com>, Tony Luck <tony.luck@intel.com>,
        linux-acpi@vger.kernel.org, linux-kernel@vger.kernel.org,
        devel@acpica.org
Date: Fri, 21 Feb 2014 09:31:58 -0700
In-Reply-To: <5306EB00.1090108@linux.intel.com>
References: <1392789739-32317-1-git-send-email-jiang.liu@linux.intel.com>
	 <60567343.brKB2SuRkR@vostro.rjw.lan> <5306EB00.1090108@linux.intel.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.8.5 (3.8.5-2.fc19) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 2014-02-21 at 13:58 +0800, Jiang Liu wrote:
> Hi Rafael,
> 	I failed to get the point to kill ACPI_HOTPLUG_OST altogether:(
> Should I merge it into my series and resend?
> 
> Hi Toshi,
> 	Any comments here?

I agree with Rafael and the change looks good to me.  linux/acpi.h
should also be changed to drop ACPI_HOTPLUG_OST.  This define was needed
originally since we relied on type-specific hotplug notify handlers to
call _OST.  We now have the ACPI common hotplug handler to take care of
_OST.

Acked-by: Toshi Kani <toshi.kani@hp.com>

Thanks,
-Toshi



