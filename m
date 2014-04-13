Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750859AbaDMVgd (ORCPT <rfc822;w@1wt.eu>);
	Sun, 13 Apr 2014 17:36:33 -0400
Received: from cpsmtpb-ews02.kpnxchange.com ([213.75.39.5]:51332 "EHLO
	cpsmtpb-ews02.kpnxchange.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750763AbaDMVgc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 13 Apr 2014 17:36:32 -0400
Message-ID: <1397424990.31896.10.camel@x220>
Subject: Re: [PATCH v2 2/3] Fix coding style problem (cast with space) in
 drivers/staging/crystalhd/crystalhd_lnx.c
From: Paul Bolle <pebolle@tiscali.nl>
To: Pascal COMBES <pascom@orange.fr>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        devel@driverdev.osuosl.org,
        Peter P Waskiewicz Jr <peter.p.waskiewicz.jr@intel.com>,
        Jarod Wilson <jarod@wilsonet.com>, Jingoo Han <jg1.han@samsung.com>,
        Valentina Manea <valentina.manea.m@gmail.com>,
        linux-kernel@vger.kernel.org, Naren Sankar <nsankar@broadcom.com>,
        Monam Agarwal <monamagarwal123@gmail.com>,
        Scott Davilla <davilla@4pi.com>,
        Amarjargal Gundjalam <amarjargal16@gmail.com>,
        Dan Carpenter <dan.carpenter@oracle.com>,
        Robert Foss <dev@robertfoss.se>
Date: Sun, 13 Apr 2014 23:36:30 +0200
In-Reply-To: <534AE1D6.1040304@orange.fr>
References: <534AAED2.7050205@orange.fr> <20140413154859.GA18189@kroah.com>
	 <534AE1D6.1040304@orange.fr>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.10.4 (3.10.4-2.fc20) 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
X-OriginalArrivalTime: 13 Apr 2014 21:36:31.0285 (UTC) FILETIME=[6F4D5650:01CF5760]
X-RcptDomain: vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-04-13 at 21:13 +0200, Pascal COMBES wrote:
> From: Pascal COMBES <pascom@orange.fr>
> 
> Fix coding style problem in drivers/staging/crystalhd/crystalhd_lnx.c:
> No space needed before a cast.
> 
> Signed-off-by: Pascal COMBES <pascom@orange.fr>
> ---
> diff --git a/drivers/staging/crystalhd/crystalhd_lnx.c b/drivers/staging/crystalhd/crystalhd_lnx.c
> index fd7f08a..15e8f02 100644
> --- a/drivers/staging/crystalhd/crystalhd_lnx.c
> +++ b/drivers/staging/crystalhd/crystalhd_lnx.c
> @@ -28,7 +28,7 @@ static struct crystalhd_adp *g_adp_info;
>  
>  static irqreturn_t chd_dec_isr(int irq, void *arg)
>  {
> -	struct crystalhd_adp *adp = (struct crystalhd_adp *) arg;
> +	struct crystalhd_adp *adp = (struct crystalhd_adp *)arg;

Shouldn't this cast just be dropped instead?

>  	int rc = 0;
>  	if (adp)
>  		rc = crystalhd_cmd_interrupt(&adp->cmds);
> 


Paul Bolle

