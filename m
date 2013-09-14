Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932348Ab3INScU (ORCPT <rfc822;w@1wt.eu>);
	Sat, 14 Sep 2013 14:32:20 -0400
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:48809 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932245Ab3INScI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 14 Sep 2013 14:32:08 -0400
Date: Sat, 14 Sep 2013 20:31:56 +0200
From: Jean Delvare <khali@linux-fr.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Introduce hwmon_device_register_with_groups and
Message-ID: <20130914203156.55e4b885@endymion.delvare>
In-Reply-To: <5224E62F.1050400@roeck-us.net>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
	<5224E62F.1050400@roeck-us.net>
X-Mailer: Claws Mail 3.9.0 (GTK+ 2.24.18; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Mon, 02 Sep 2013 12:25:35 -0700, Guenter Roeck wrote:
> On 08/31/2013 07:48 PM, Guenter Roeck wrote:
> > This patch series introduces new hwmon API functions
> > hwmon_device_register_with_groups() and devm_hwmon_device_register_with_groups().
> >
> > hwmon_device_register_with_groups() lets callers register hwmon devices
> > as well as associated sysfs attributes with a single call. This simplifies
> > hwmon device registration and avoids potential race conditions seen
> > if sysfs attributes are created after the initial hwmon device was
> > registered.
> >
> > devm_hwmon_device_register_with_groups() is the managed version of the same
> > function.
> >
> Jean, any comments on this patch series ?
> 
> If you are ok with it, I would like to push the new API (patches 1 and 7 of the series)
> into 3.12, and keep the rest for 3.13.

I'm afraid I won't have the time to review all these patches. The
concept looks good to me and I trust that you implemented things right
so feel free to push the patches upstream even without my review.

-- 
Jean Delvare
