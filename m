Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932528Ab3KZS65 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 13:58:57 -0500
Received: from mail-pb0-f42.google.com ([209.85.160.42]:53982 "EHLO
	mail-pb0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932405Ab3KZS6u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 13:58:50 -0500
Date: Tue, 26 Nov 2013 10:58:46 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Guenter Roeck <linux@roeck-us.net>
Cc: linux-input@vger.kernel.org, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2] Input: ads7846: Convert to
 hwmon_device_register_with_groups
Message-ID: <20131126185846.GB22242@core.coreip.homeip.net>
References: <1385440744-6607-1-git-send-email-linux@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385440744-6607-1-git-send-email-linux@roeck-us.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Guenter,

On Mon, Nov 25, 2013 at 08:39:04PM -0800, Guenter Roeck wrote:
> Simplify the code and create mandatory 'name' attribute by using
> new hwmon API.

So this moves hwmon attributes from the parent i2c device to the hwmon
device, right? Would not that break userspace which expects to find the
attributes where they were?

Thanks.

-- 
Dmitry
