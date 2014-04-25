Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752101AbaDYHul (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Apr 2014 03:50:41 -0400
Received: from aserp1040.oracle.com ([141.146.126.69]:40401 "EHLO
	aserp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751889AbaDYHuk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Apr 2014 03:50:40 -0400
Date: Fri, 25 Apr 2014 10:50:20 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Nicolas Del Piano <ndel314@gmail.com>
Cc: gregkh@linuxfoundation.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org, mail@berndporr.me.uk,
        Joe Perches <joe@perches.com>
Subject: Re: [PATCH] Staging: comedi: drivers: fixed a  coding style issue.
Message-ID: <20140425075020.GF26890@mwanda>
References: <5359DF54.50607@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5359DF54.50607@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet22.oracle.com [141.146.126.238]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Patches need to be sent inline.  Perhaps use git send-email.


On Fri, Apr 25, 2014 at 01:06:44AM -0300, Nicolas Del Piano wrote:
> 
> >From 38e0d5778bd97062115e7d8a8ca40d18f3d71707 Mon Sep 17 00:00:00 2001
> From: Nicolas Del Piano <ndel314@gmail.com>
> Date: Thu, 24 Apr 2014 18:46:49 -0300
> Subject: [PATCH] Staging: comedi: drivers: fixed a missing blank line after a
>  declaration coding style.
> 

We don't want these headers in the patch.

> Fixed a coding style issue.
> 
> Signed-off-by: Nicolas Del Piano <ndel314@gmail.com>
> ---
>  drivers/staging/comedi/drivers.c |    1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/comedi/drivers.c b/drivers/staging/comedi/drivers.c
> index cb5d214..71569bc 100644
> --- a/drivers/staging/comedi/drivers.c
> +++ b/drivers/staging/comedi/drivers.c
> @@ -439,6 +439,7 @@ static void *comedi_recognize(struct comedi_driver *driv, const char *name)
>  static void comedi_report_boards(struct comedi_driver *driv)
>  {
>  	unsigned int i;
> +
>  	const char *const *name_ptr;

The original code was correct.  This is a bug in checkpatch.pl.  The
missing line check should count any lines starting with "const" or
"static" as declarations.

regards,
dan carpenter

