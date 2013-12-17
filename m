Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754832Ab3LQQfM (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 11:35:12 -0500
Received: from relay5-d.mail.gandi.net ([217.70.183.197]:33938 "EHLO
	relay5-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752800Ab3LQQfJ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 11:35:09 -0500
X-Originating-IP: 50.43.14.201
Date: Tue, 17 Dec 2013 08:35:02 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Len Brown <lenb@kernel.org>,
        sfi-devel@simplefirmware.org
Subject: Re: [PATCH 1/2] drivers: sfi: Include appropriate headers in
 sfi_acpi.c
Message-ID: <20131217163502.GC737@leaf>
References: <c351cee2521c4728d60810eb0212e8f307c79ac6.1387283325.git.rashika.kheria@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <c351cee2521c4728d60810eb0212e8f307c79ac6.1387283325.git.rashika.kheria@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 17, 2013 at 06:02:14PM +0530, Rashika Kheria wrote:
> Include header file include/linux/sfi_acpi.h in sfi_acpi.c because
> function sfi_acpi_table_parse() has its prototype declaration in
> include/linux/sfi_acpi.h. Also, include include/linux/acpi.h because it
> contains declarations necessary for include/linux/sfi_acpi.h.
> 
> This eliminates the following warning in sfi_acpi.c:
> drivers/sfi/sfi_acpi.c:154:5: warning: no previous prototype for ‘sfi_acpi_table_parse’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/sfi/sfi_acpi.c |    2 ++
>  1 file changed, 2 insertions(+)
> 
> diff --git a/drivers/sfi/sfi_acpi.c b/drivers/sfi/sfi_acpi.c
> index f5b4ca5..95023f9 100644
> --- a/drivers/sfi/sfi_acpi.c
> +++ b/drivers/sfi/sfi_acpi.c
> @@ -60,6 +60,8 @@
>  #define pr_fmt(fmt) KMSG_COMPONENT ": " fmt
>  
>  #include <linux/kernel.h>
> +#include <linux/acpi.h>
> +#include <linux/sfi_acpi.h>
>  #include <acpi/acpi.h>
>  
>  #include <linux/sfi.h>
> -- 
> 1.7.9.5
> 
