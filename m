Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756226Ab3HWUr4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 16:47:56 -0400
Received: from mail-pb0-f53.google.com ([209.85.160.53]:59122 "EHLO
	mail-pb0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755953Ab3HWUry (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 16:47:54 -0400
Date: Fri, 23 Aug 2013 13:47:52 -0700
From: Guenter Roeck <linux@roeck-us.net>
To: Wei Hu <wei@aristanetworks.com>
Cc: Guenter Roeck <groeck7@gmail.com>, Clemens Ladisch <clemens@ladisch.de>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Subject: Re: [lm-sensors] [PATCH] hwmon: (k10temp) Add support for Fam16h
 (Kabini)
Message-ID: <20130823204752.GA19363@roeck-us.net>
References: <20130823195810.GA12208@roeck-us.net>
 <1377288843-18253-1-git-send-email-wei@aristanetworks.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1377288843-18253-1-git-send-email-wei@aristanetworks.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 23, 2013 at 01:14:03PM -0700, Wei Hu wrote:
> The temperature reporting interface stays the same, so we just
> add the PCI-ID to the list.
> 
> Verified on AMD Olive Hill.
> 
> Signed-off-by: Wei Hu <wei@aristanetworks.com>

Applied to -next.

I marked it for inclusion in stable-3.10, so it will ultimately find
its way there. It does not apply cleanly to earlier stable releases.
If is needed in any of those, someone will have to back-port it after
it is available in mainline.

Thanks,
Guenter
