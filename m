Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755364Ab3C0Kpq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Mar 2013 06:45:46 -0400
Received: from cantor2.suse.de ([195.135.220.15]:41542 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755258Ab3C0Kpp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Mar 2013 06:45:45 -0400
Date: Wed, 27 Mar 2013 11:45:43 +0100 (CET)
From: Jiri Kosina <jkosina@suse.cz>
To: Paul Bolle <pebolle@tiscali.nl>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] [TRIVIAL] fix comment typo "CONFIG_HID_PICOLCD_LIRC"
In-Reply-To: <1364241121.1390.292.camel@x61.thuisdomein>
Message-ID: <alpine.LNX.2.00.1303271145340.23442@pobox.suse.cz>
References: <1364241121.1390.292.camel@x61.thuisdomein>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 25 Mar 2013, Paul Bolle wrote:

> Signed-off-by: Paul Bolle <pebolle@tiscali.nl>
> ---
> Untested.
> 
>  drivers/hid/hid-picolcd.h | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git a/drivers/hid/hid-picolcd.h b/drivers/hid/hid-picolcd.h
> index 020cef6..88c7c93 100644
> --- a/drivers/hid/hid-picolcd.h
> +++ b/drivers/hid/hid-picolcd.h
> @@ -302,7 +302,7 @@ static inline int picolcd_init_cir(struct picolcd_data *data, struct hid_report
>  static inline void picolcd_exit_cir(struct picolcd_data *data)
>  {
>  }
> -#endif /* CONFIG_HID_PICOLCD_LIRC */
> +#endif /* CONFIG_HID_PICOLCD_CIR */

Applied to hid.git, thanks.

-- 
Jiri Kosina
SUSE Labs
