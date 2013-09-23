Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754449Ab3IWWps (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 18:45:48 -0400
Received: from mail-pd0-f179.google.com ([209.85.192.179]:51233 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751555Ab3IWWpq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 18:45:46 -0400
Date: Mon, 23 Sep 2013 15:45:41 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>
Cc: Jean Delvare <khali@linux-fr.org>, Fenghua Yu <fenghua.yu@intel.com>,
        "Artem S. Tashkinov" <t.artem@mailcity.com>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-pm@vger.kernel.org
Subject: Re: [PATCH v5 2/2] hwmon: (coretemp) Report power and energy
 consumption
Message-ID: <20130923224541.GA25966@roeck-us.net>
References: <1379968489-13781-1-git-send-email-linux@roeck-us.net>
 <1379968489-13781-2-git-send-email-linux@roeck-us.net>
 <5240C145.6080104@linux.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5240C145.6080104@linux.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 03:31:33PM -0700, Srinivas Pandruvada wrote:
> On 09/23/2013 01:34 PM, Guenter Roeck wrote:
> >Supported by SandyBridge and newer CPUs.
> >
> >Cc: Fenghua Yu <fenghua.yu@intel.com>
> >Signed-off-by: Guenter Roeck <linux@roeck-us.net>
> >---
> >v5: Merged to 3.12-rc1
> >v4: Replaced INIT_DELAYED_WORK with INIT_DEFERRABLE_WORK
> >v3: Added Cc:
> >v2: Fix missing symbol error on i386 builds
> >     Dropped leftover pr_info from debugging
> >
> >I am inclined to drop this patch set, as I received neither test nor code
> >review feedback even though the patch set has been out there for a long time.
> >Also, I am concerned that it overlaps or even conflicts with the proposed
> >Power Cap/RAPL driver (https://lkml.org/lkml/2013/9/19/260).
> <We feel that the power capping framework is the right place to show
> the RAPL data. This is not just monitoring but also control.
> There are other drivers getting developed using this framework to
> expose an uniform sysfs interface.

Thought so. Have you thought about providing a hwmon bridge ?

Thanks,
Guenter
