Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932266Ab3L3Uuy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 30 Dec 2013 15:50:54 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:58573 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932172Ab3L3Uuv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 30 Dec 2013 15:50:51 -0500
X-Originating-IP: 50.43.14.201
Date: Mon, 30 Dec 2013 12:50:41 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: "Zheng, Lv" <lv.zheng@intel.com>
Cc: "Moore, Robert" <robert.moore@intel.com>,
        Rashika Kheria <rashika.kheria@gmail.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "Wysocki, Rafael J" <rafael.j.wysocki@intel.com>,
        Len Brown <lenb@kernel.org>,
        "linux-acpi@vger.kernel.org" <linux-acpi@vger.kernel.org>,
        "devel@acpica.org" <devel@acpica.org>
Subject: Re: [PATCH 05/11] drivers: acpi: Include appropriate header file in
 utstate.c
Message-ID: <20131230205041.GT27213@leaf>
References: <c676af6619fc5a84208740bfc7edcf56bb78ed4e.1387271324.git.rashika.kheria@gmail.com>
 <c8f6f6fbcd7de593a726d091f5d0f6a245f6e0f7.1387271324.git.rashika.kheria@gmail.com>
 <94F2FBAB4432B54E8AACC7DFDE6C92E37C7B99F5@ORSMSX103.amr.corp.intel.com>
 <1AE640813FDE7649BE1B193DEA596E88024987F6@SHSMSX101.ccr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1AE640813FDE7649BE1B193DEA596E88024987F6@SHSMSX101.ccr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 18, 2013 at 06:17:33AM +0000, Zheng, Lv wrote:
> Currently we didn't do much on automatically optimized out ACPI_FUTURE_USAGE functions as long as they do not affect the generation of vmlinux binary.

They do affect the size of vmlinux, though, if they're left compiled in
but not actually called.

> I have a plan to do a cleanup on all ACPICA build warnings so that such inconsistencies can be sorted out.
> Maybe it is time to do it right now.

That would be most appreciated, especially if you plan to eliminate the
warnings from -Wmissing-prototypes in the process.

Thanks,
Josh Triplett
