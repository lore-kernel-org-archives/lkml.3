Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756060AbaFYUsA (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Jun 2014 16:48:00 -0400
Received: from mail-pb0-f47.google.com ([209.85.160.47]:34330 "EHLO
	mail-pb0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754608AbaFYUr7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Jun 2014 16:47:59 -0400
Date: Wed, 25 Jun 2014 13:47:45 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: "Julien D'Ascenzio" <jdascenzio@yahoo.fr>
Cc: Jean Delvare <jdelvare@suse.de>, lm-sensors@lm-sensors.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] hwmon: (gpio-fan) Change name used in
 hwmon_device_register_with_groups
Message-ID: <20140625204745.GB14652@roeck-us.net>
References: <1403726431-18749-1-git-send-email-jdascenzio@yahoo.fr>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403726431-18749-1-git-send-email-jdascenzio@yahoo.fr>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 25, 2014 at 10:00:31PM +0200, Julien D'Ascenzio wrote:
> Since commit 648cd48c9e566f53c5df30d79857e0937ae13b09
> The hwmon name attributes must not include '-' so the name must be
> rename from gpio-fan to gpio_fan
> 
> Signed-off-by: Julien D'Ascenzio <jdascenzio@yahoo.fr>

Good catch. Applied.

Thanks,
Guenter
