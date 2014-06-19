Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756804AbaFSULo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 16:11:44 -0400
Received: from relay3-d.mail.gandi.net ([217.70.183.195]:48083 "EHLO
	relay3-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756215AbaFSULn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 16:11:43 -0400
Date: Thu, 19 Jun 2014 13:11:40 -0700
From: josh@joshtriplett.org
To: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
Cc: devel@linuxdriverproject.org,
        Maximilian Eschenbacher <maximilian@eschenbacher.email>,
        linux-kernel@i4.cs.fau.de,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Himangi Saraogi <himangi774@gmail.com>,
        Vitaly Osipov <vitaly.osipov@gmail.com>, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/8] wlan-ng/prism2mgmt:checkpatch: Insert blank line
Message-ID: <20140619201140.GB16404@cloud>
References: <1403205620-10219-1-git-send-email-Johannes.Stadlinger@fau.de>
 <1403205620-10219-3-git-send-email-Johannes.Stadlinger@fau.de>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403205620-10219-3-git-send-email-Johannes.Stadlinger@fau.de>
User-Agent: Mutt/1.5.20 (2009-06-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 09:20:15PM +0200, Johannes Stadlinger wrote:
> This patch inserts a blank line after a declaration to avoid checkpatch
> warning.
> 
> Signed-off-by: Johannes Stadlinger <Johannes.Stadlinger@fau.de>
> Signed-off-by: Maximilian Eschenbacher <maximilian@eschenbacher.email>
> CC: linux-kernel@i4.cs.fau.de
> CC: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> CC: Josh Triplett <josh@joshtriplett.org>
> CC: Himangi Saraogi <himangi774@gmail.com>
> CC: Vitaly Osipov <vitaly.osipov@gmail.com>
> CC: devel@driverdev.osuosl.org
> CC: linux-kernel@vger.kernel.org

This is one case where I think checkpatch is just wrong; this doesn't
make the code any more (or less) readable.

Meh-by: Josh Triplett <josh@joshtriplett.org>

>  drivers/staging/wlan-ng/prism2mgmt.c | 1 +
>  1 file changed, 1 insertion(+)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mgmt.c b/drivers/staging/wlan-ng/prism2mgmt.c
> index f90f7da..e6a82d3 100644
> --- a/drivers/staging/wlan-ng/prism2mgmt.c
> +++ b/drivers/staging/wlan-ng/prism2mgmt.c
> @@ -190,6 +190,7 @@ int prism2mgmt_scan(wlandevice_t *wlandev, void *msgp)
>  	word = 0;
>  	for (i = 0; i < msg->channellist.data.len; i++) {
>  		u8 channel = msg->channellist.data.data[i];
> +
>  		if (channel > 14)
>  			continue;
>  		/* channel 1 is BIT 0 ... channel 14 is BIT 13 */
> -- 
> 1.9.1
> 
