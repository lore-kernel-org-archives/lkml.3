Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934441AbaFSUPF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:15:05 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:39583 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932071AbaFSUPD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:15:03 -0400
Date: Thu, 19 Jun 2014 13:14:59 -0700
From: josh@joshtriplett.org
To: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Cc: devel@linuxdriverproject.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Vitaly Osipov <vitaly.osipov@gmail.com>,
        Himangi Saraogi <himangi774@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 5/8] wlan-ng/prism2mib:checkpatch: Insert blank lines
Message-ID: <20140619201459.GD16404@cloud>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
 <1403205620-10219-5-git-send-email-Johannes.Stadlinger@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403205620-10219-5-git-send-email-Johannes.Stadlinger@fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:20:17PM +0200, Johannes Stadlinger wrote:
> This patch inserts blank lines after declarations to avoid checkpatch
> warning.
> 
> After our fixes in 'wlan-ng/prism2mib.c' there are still two checkpatch
> warnings about lines over 80 characters remaining.
> 
> Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> CC: linux-kernel@i4.cs.fau.de
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Vitaly Osipov <vitaly.osipov@gmail.com>
> CC: Himangi Saraogi <himangi774@gmail.com>
> CC: devel@driverdev.osuosl.org
> CC: linux-kernel@vger.kernel.org
> ---
>  drivers/staging/wlan-ng/prism2mib.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
> index bdd3b4c..3ea24d6 100644
> --- a/drivers/staging/wlan-ng/prism2mib.c
> +++ b/drivers/staging/wlan-ng/prism2mib.c
> @@ -85,7 +85,8 @@ struct mibrec {
>  	u16 parm1;
>  	u16 parm2;
>  	u16 parm3;
> -	int (*func) (struct mibrec *mib,
> +
> +	int (*func)(struct mibrec *mib,

Eliminating the space here makes sense, but checkpatch shouldn't warn
about spaces after declarations between two fields in the middle of a
structure declaration.

>  		     int isget,
>  		     wlandevice_t *wlandev,
>  		     hfa384x_t *hw,
> @@ -722,6 +723,7 @@ static int prism2mib_priv(struct mibrec *mib,
>  	switch (mib->did) {
>  	case DIDmib_lnx_lnxConfigTable_lnxRSNAIE:{
>  			hfa384x_WPAData_t wpa;
> +
>  			if (isget) {
>  				hfa384x_drvr_getconfig(hw,
>  						       HFA384x_RID_CNFWPADATA,
> -- 
> 1.9.1
> 
