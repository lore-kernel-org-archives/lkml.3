Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752930AbaAWQiV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 23 Jan 2014 11:38:21 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:35132 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751908AbaAWQiT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 23 Jan 2014 11:38:19 -0500
Date: Thu, 23 Jan 2014 17:38:09 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: <linux-kernel@vger.kernel.org>, <linux-arch@vger.kernel.org>,
        Guenter Roeck <linux@roeck-us.net>, <lm-sensors@lm-sensors.org>
Subject: Re: [PATCH 50/73] drivers/hwmon: delete non-required instances of
 include <linux/init.h>
Message-ID: <20140123173809.3ef03409@endymion.delvare>
In-Reply-To: <1390339396-3479-51-git-send-email-paul.gortmaker@windriver.com>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
	<1390339396-3479-51-git-send-email-paul.gortmaker@windriver.com>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Paul,

On Tue, 21 Jan 2014 16:22:53 -0500, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>
> ---
> (...)

Looks good to me, and thanks for doing that.

Acked-by: Jean Delvare <khali@linux-fr.org>

-- 
Jean Delvare
