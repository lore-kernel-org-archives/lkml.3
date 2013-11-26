Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758078Ab3KZTgv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 14:36:51 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:15986 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754496Ab3KZTgu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 14:36:50 -0500
Date: Tue, 26 Nov 2013 20:36:34 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Dmitry Torokhov <dmitry.torokhov@gmail.com>
Cc: Guenter Roeck <linux@roeck-us.net>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org, linux-input@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH v2] Input: ads7846: Convert to 
 hwmon_device_register_with_groups
Message-ID: <20131126203634.05c7baa1@endymion.delvare>
In-Reply-To: <20131126185846.GB22242@core.coreip.homeip.net>
References: <1385440744-6607-1-git-send-email-linux@roeck-us.net>
	<20131126185846.GB22242@core.coreip.homeip.net>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Dmitry,

On Tue, 26 Nov 2013 10:58:46 -0800, Dmitry Torokhov wrote:
> On Mon, Nov 25, 2013 at 08:39:04PM -0800, Guenter Roeck wrote:
> > Simplify the code and create mandatory 'name' attribute by using
> > new hwmon API.
> 
> So this moves hwmon attributes from the parent i2c device to the hwmon
> device, right? Would not that break userspace which expects to find the
> attributes where they were?

libsensors supports that just fine since version 3.0.3 which was
released in September 2008, over 5 years ago.

Applications bypassing libsensors are on their own, and always have
been. But several other drivers have had their attributes in the hwmon
device forever so even these applications are likely to be happy with
other drivers moving in that direction.

-- 
Jean Delvare
