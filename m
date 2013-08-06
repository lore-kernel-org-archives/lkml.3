Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756557Ab3HFX5U (ORCPT <rfc822;w@1wt.eu>);
	Tue, 6 Aug 2013 19:57:20 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:63775 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755702Ab3HFX5S (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 6 Aug 2013 19:57:18 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Anton Vorontsov <anton@enomsg.org>
Cc: "Rafael J. Wysocki" <rjw@sisk.pl>, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, David Woodhouse <dwmw2@infradead.org>,
        Nishanth Menon <nm@ti.com>
Subject: Re: [PATCH] MAINTAINERS: drivers/power: add entry for SmartReflex AVS drivers
References: <1375720177-20063-1-git-send-email-khilman@linaro.org>
	<20130806015147.GA16668@teo>
Date: Tue, 06 Aug 2013 16:57:14 -0700
In-Reply-To: <20130806015147.GA16668@teo> (Anton Vorontsov's message of "Mon,
	5 Aug 2013 18:51:48 -0700")
Message-ID: <87mwoufk4l.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Anton Vorontsov <anton@enomsg.org> writes:

> On Mon, Aug 05, 2013 at 09:29:37AM -0700, Kevin Hilman wrote:
>> The SmartReflex AVS driver evolved out of the OMAP kernel and now
>> lives under drivers/power/avs.
>> 
>> I've historically been maintainer of this but Nishanth Menon is doing
>> most of the heavy lifting now.  Add us both as co-maintainers.
>> 
> ...
>> +M:	Kevin Hilman <khilman@kernel.org>
>> +M:	Nishanth Menon <nm@ti.com>
>> +S:	Maintained
>> +F:	drivers/power/avs/smartreflex.c
>> +F:      include/linux/power/smartreflex.h
>
> This line is borken (whitespaces).

doh, here's a fixed version.


>From 4032435bb07f92993a8c70d64337d8513f88565c Mon Sep 17 00:00:00 2001
From: Kevin Hilman <khilman@linaro.org>
Date: Mon, 5 Aug 2013 09:19:34 -0700
Subject: [PATCH] MAINTAINERS: drivers/power: add entry for SmartReflex AVS
 drivers

The SmartReflex AVS driver evolved out of the OMAP kernel and now
lives under drivers/power/avs.

I've historically been maintainer of this but Nishanth Menon is doing
most of the heavy lifting now.  Add us both as co-maintainers.

Cc: Anton Vorontsov <anton@enomsg.org>
Cc: David Woodhouse <dwmw2@infradead.org>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: Nishanth Menon <nm@ti.com>
Signed-off-by: Kevin Hilman <khilman@linaro.org>
---
 MAINTAINERS | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/MAINTAINERS b/MAINTAINERS
index defc053..93e9ba0 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -6450,6 +6450,14 @@ S:	Maintained
 F:	include/linux/power_supply.h
 F:	drivers/power/
 
+SMARTREFLEX DRIVERS FOR ADAPTIVE VOLTAGE SCALING (AVS)
+M:	Kevin Hilman <khilman@kernel.org>
+M:	Nishanth Menon <nm@ti.com>
+S:	Maintained
+F:	drivers/power/avs/smartreflex.c
+F:	include/linux/power/smartreflex.h
+L:	linux-pm@vger.kernel.org
+
 PNP SUPPORT
 M:	Rafael J. Wysocki <rafael.j.wysocki@intel.com>
 M:	Bjorn Helgaas <bhelgaas@google.com>
-- 
1.8.3

