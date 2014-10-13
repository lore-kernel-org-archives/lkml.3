Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753003AbaJMD2M (ORCPT <rfc822;w@1wt.eu>);
	Sun, 12 Oct 2014 23:28:12 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:46482 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752836AbaJMD2L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 12 Oct 2014 23:28:11 -0400
Date: Mon, 13 Oct 2014 05:27:08 +0200
From: Greg KH <gregkh@linuxfoundation.org>
To: Erich Cordoba Malibran <erich.cordoba@yandex.com>
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org
Subject: Re: [PATCH] staging: wlan-ng: Renamed prism2_fragmenthreshold in
 prism2mib.c
Message-ID: <20141013032708.GB26646@kroah.com>
References: <1413167372-5568-1-git-send-email-erich.cordoba@yandex.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1413167372-5568-1-git-send-email-erich.cordoba@yandex.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Oct 12, 2014 at 09:29:32PM -0500, Erich Cordoba Malibran wrote:
> From: Erich Cordoba Malibran <erich.cordoba@yandex.com>
> 
> Renamed function to fix style issues.

Why is changing a name, to a misspelled one, a "style issue fix"?


> 
> Signed-off-by: Erich Cordoba Malibran <erich.cordoba@yandex.com>
> ---
>  drivers/staging/wlan-ng/prism2mib.c | 26 +++++++++++++-------------
>  1 file changed, 13 insertions(+), 13 deletions(-)
> 
> diff --git a/drivers/staging/wlan-ng/prism2mib.c b/drivers/staging/wlan-ng/prism2mib.c
> index 0163e06..30d224f 100644
> --- a/drivers/staging/wlan-ng/prism2mib.c
> +++ b/drivers/staging/wlan-ng/prism2mib.c
> @@ -132,12 +132,12 @@ static int prism2mib_excludeunencrypted(struct mibrec *mib,
>  					struct p80211msg_dot11req_mibset *msg,
>  					void *data);
>  
> -static int prism2mib_fragmentationthreshold(struct mibrec *mib,
> -					    int isget,
> -					    wlandevice_t *wlandev,
> -					    hfa384x_t *hw,
> -					    struct p80211msg_dot11req_mibset *msg,
> -					    void *data);
> +static int prism2mib_fragmenthreshold(struct mibrec *mib,
> +				      int isget,
> +				      wlandevice_t *wlandev,
> +				      hfa384x_t *hw,
> +				      struct p80211msg_dot11req_mibset *msg,
> +				      void *data);
>  
>  static int prism2mib_priv(struct mibrec *mib,
>  			  int isget,
> @@ -198,7 +198,7 @@ static struct mibrec mibtab[] = {
>  	{DIDmib_dot11mac_dot11OperationTable_dot11FragmentationThreshold,
>  	 F_STA | F_READ | F_WRITE,
>  	 HFA384x_RID_FRAGTHRESH, 0, 0,
> -	 prism2mib_fragmentationthreshold},
> +	 prism2mib_fragmenthreshold},
>  	{DIDmib_dot11mac_dot11OperationTable_dot11MaxTransmitMSDULifetime,
>  	 F_STA | F_READ,
>  	 HFA384x_RID_MAXTXLIFETIME, 0, 0,
> @@ -660,12 +660,12 @@ static int prism2mib_excludeunencrypted(struct mibrec *mib,
>  *
>  ----------------------------------------------------------------*/
>  
> -static int prism2mib_fragmentationthreshold(struct mibrec *mib,
> -					    int isget,
> -					    wlandevice_t *wlandev,
> -					    hfa384x_t *hw,
> -					    struct p80211msg_dot11req_mibset *msg,
> -					    void *data)
> +static int prism2mib_fragmenthreshold(struct mibrec *mib,
> +				      int isget,
> +				      wlandevice_t *wlandev,
> +				      hfa384x_t *hw,
> +				      struct p80211msg_dot11req_mibset *msg,
> +				      void *data)
>  {
>  	int result;
>  	u32 *uint32 = (u32 *) data;
> -- 
> 2.1.2

I don't understand the problem you are trying to solve here, what is it?

confused,

greg k-h
