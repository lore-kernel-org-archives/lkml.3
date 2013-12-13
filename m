Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752503Ab3LMI7j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 03:59:39 -0500
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39772 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751636Ab3LMI7i convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 03:59:38 -0500
X-Originating-IP: 50.43.14.201
Date: Fri, 13 Dec 2013 00:59:32 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org
Subject: Re: [PATCH 2/2] drivers: platform: Include appropriate header file
 in mxm-wmi.c
Message-ID: <20131213085932.GG4386@leaf>
References: <89355c5023baba63de7d1313b3f52818b0fb9202.1386919194.git.rashika.kheria@gmail.com>
 <6614158e1dfcda1c77d22a2dd944a2e341346221.1386919194.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <6614158e1dfcda1c77d22a2dd944a2e341346221.1386919194.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Dec 13, 2013 at 12:59:52PM +0530, Rashika Kheria wrote:
> This patch includes appropriate header file linux/mxm-wmi.h in
> x86/mxm-wmi.c because functions mxm_wmi_call_mxds(), mxm_wmi_call_mxmx()
> and mxm_wmi_supported() have their prototype declaration in
> linux/mxm-wmi.h.
> 
> Thus, it also eliminates the following warnings in x86/mxm-wmi.c:
> drivers/platform/x86/mxm-wmi.c:43:5: warning: no previous prototype for ‘mxm_wmi_call_mxds’ [-Wmissing-prototypes]
> drivers/platform/x86/mxm-wmi.c:68:5: warning: no previous prototype for ‘mxm_wmi_call_mxmx’ [-Wmissing-prototypes]
> drivers/platform/x86/mxm-wmi.c:93:6: warning: no previous prototype for ‘mxm_wmi_supported’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/platform/x86/mxm-wmi.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/platform/x86/mxm-wmi.c b/drivers/platform/x86/mxm-wmi.c
> index 0aea63b..7503d2b 100644
> --- a/drivers/platform/x86/mxm-wmi.c
> +++ b/drivers/platform/x86/mxm-wmi.c
> @@ -20,6 +20,7 @@
>  #include <linux/kernel.h>
>  #include <linux/module.h>
>  #include <linux/init.h>
> +#include <linux/mxm-wmi.h>
>  #include <acpi/acpi_bus.h>
>  #include <acpi/acpi_drivers.h>
>  
> -- 
> 1.7.9.5
> 
