Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754669Ab3LUKzn (ORCPT <rfc822;w@1wt.eu>);
	Sat, 21 Dec 2013 05:55:43 -0500
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:42052 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751291Ab3LUKzm convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 21 Dec 2013 05:55:42 -0500
X-Originating-IP: 50.43.14.201
Date: Sat, 21 Dec 2013 02:55:36 -0800
From: Josh Triplett <josh@joshtriplett.org>
To: Rashika Kheria <rashika.kheria@gmail.com>
Cc: linux-kernel@vger.kernel.org, Lidza Louina <lidza.louina@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH 1/2] drivers: dgap: Include appropriate header file in
 dgap_parse.c
Message-ID: <20131221105536.GF3611@leaf>
References: <20131221102550.GA3229@rashika>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20131221102550.GA3229@rashika>
User-Agent: Mutt/1.5.21 (2010-09-15)
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Dec 21, 2013 at 03:55:50PM +0530, Rashika Kheria wrote:
> Include appropriate header file in dgap/dgap_parse.h in dgap_parse.c
> because functions dgap_parsefile(), dgap_config_get_useintr(),
> dgap_config_get_altpin(), dgap_find_config(),
> dgap_config_get_number_of_ports(), dgap_create_config_string() and
> dgap_get_config_letters() have their prototype declarations in the
> header file.
> 
> This eliminates the following warnings in dgap_parse.c:
> drivers/staging/dgap/dgap_parse.c:125:5: warning: no previous prototype for ‘dgap_parsefile’ [-Wmissing-prototypes]
> drivers/staging/dgap/dgap_parse.c:1101:6: warning: no previous prototype for ‘dgap_config_get_useintr’ [-Wmissing-prototypes]
> drivers/staging/dgap/dgap_parse.c:1128:6: warning: no previous prototype for ‘dgap_config_get_altpin’ [-Wmissing-prototypes]
> drivers/staging/dgap/dgap_parse.c:1157:15: warning: no previous prototype for ‘dgap_find_config’ [-Wmissing-prototypes]
> drivers/staging/dgap/dgap_parse.c:1223:6: warning: no previous prototype for ‘dgap_config_get_number_of_ports’ [-Wmissing-prototypes]
> drivers/staging/dgap/dgap_parse.c:1252:7: warning: no previous prototype for ‘dgap_create_config_string’ [-Wmissing-prototypes]
> drivers/staging/dgap/dgap_parse.c:1311:7: warning: no previous prototype for ‘dgap_get_config_letters’ [-Wmissing-prototypes]
> 
> Signed-off-by: Rashika Kheria <rashika.kheria@gmail.com>

Reviewed-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/dgap/dgap_parse.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/dgap/dgap_parse.c b/drivers/staging/dgap/dgap_parse.c
> index ff9d194..36fd93d 100644
> --- a/drivers/staging/dgap/dgap_parse.c
> +++ b/drivers/staging/dgap/dgap_parse.c
> @@ -42,6 +42,7 @@
>  #include "dgap_types.h"
>  #include "dgap_fep5.h"
>  #include "dgap_driver.h"
> +#include "dgap_parse.h"
>  #include "dgap_conf.h"
>  
>  
> -- 
> 1.7.9.5
> 
