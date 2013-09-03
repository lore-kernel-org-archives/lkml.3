Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756407Ab3ICP1j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 11:27:39 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:62822 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753956Ab3ICP1i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 11:27:38 -0400
Date: Tue, 3 Sep 2013 08:27:31 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Jean Delvare <khali@linux-fr.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 0/9] Introduce hwmon_device_register_with_groups and
Message-ID: <20130903152731.GB20159@roeck-us.net>
References: <1378003742-18685-1-git-send-email-linux@roeck-us.net>
 <5224E62F.1050400@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5224E62F.1050400@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 02, 2013 at 12:25:35PM -0700, Guenter Roeck wrote:
> On 08/31/2013 07:48 PM, Guenter Roeck wrote:
> >This patch series introduces new hwmon API functions
> >hwmon_device_register_with_groups() and devm_hwmon_device_register_with_groups().
> >
> >hwmon_device_register_with_groups() lets callers register hwmon devices
> >as well as associated sysfs attributes with a single call. This simplifies
> >hwmon device registration and avoids potential race conditions seen
> >if sysfs attributes are created after the initial hwmon device was
> >registered.
> >
> >devm_hwmon_device_register_with_groups() is the managed version of the same
> >function.
> >
> Jean, any comments on this patch series ?
> 
> If you are ok with it, I would like to push the new API (patches 1 and 7 of the series)
> into 3.12, and keep the rest for 3.13.
> 
The commit window opened up, so this will have to wait for 3.13.

Guenter
