Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755530AbaAUVh0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 21 Jan 2014 16:37:26 -0500
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50103 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755392AbaAUVhU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 21 Jan 2014 16:37:20 -0500
Date: Tue, 21 Jan 2014 13:37:19 -0800
From: Guenter Roeck <linux@roeck-us.net>
To: Paul Gortmaker <paul.gortmaker@windriver.com>
Cc: linux-kernel@vger.kernel.org, linux-arch@vger.kernel.org,
        Jean Delvare <khali@linux-fr.org>, lm-sensors@lm-sensors.org
Subject: Re: [PATCH 50/73] drivers/hwmon: delete non-required instances of
 include <linux/init.h>
Message-ID: <20140121213719.GA11888@roeck-us.net>
References: <1390339396-3479-1-git-send-email-paul.gortmaker@windriver.com>
 <1390339396-3479-51-git-send-email-paul.gortmaker@windriver.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1390339396-3479-51-git-send-email-paul.gortmaker@windriver.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 21, 2014 at 04:22:53PM -0500, Paul Gortmaker wrote:
> None of these files are actually using any __init type directives
> and hence don't need to include <linux/init.h>.  Most are just a
> left over from __devinit and __cpuinit removal, or simply due to
> code getting copied from one driver to the next.
> 
> Cc: Jean Delvare <khali@linux-fr.org>
> Cc: Guenter Roeck <linux@roeck-us.net>
> Cc: lm-sensors@lm-sensors.org
> Signed-off-by: Paul Gortmaker <paul.gortmaker@windriver.com>

Hi Paul,

nice cleanup. I applied it to my local repository to run
a set of build tests with it.

Assuming the plan is to push the changes through your tree:

Acked-by: Guenter Roeck <linux@roeck-us.net>

Guenter
