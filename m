Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751599Ab3EENHE (ORCPT <rfc822;w@1wt.eu>);
	Sun, 5 May 2013 09:07:04 -0400
Received: from userp1040.oracle.com ([156.151.31.81]:31521 "EHLO
	userp1040.oracle.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114Ab3EENHD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 5 May 2013 09:07:03 -0400
Date: Sun, 5 May 2013 16:06:40 +0300
From: Dan Carpenter <dan.carpenter@oracle.com>
To: Jake Champlin <jake.champlin.27@gmail.com>
Cc: willy@meta-x.org, gregkh@linuxfoundation.org, yamanetoshi@gmail.com,
        adam.buchbinder@gmail.com, peterhuewe@gmx.de, fengguang.wu@intel.com,
        devel@driverdev.osuosl.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] Staging: Panel: panel: Fixed checkpatch line length
 warnings
Message-ID: <20130505130640.GA4686@mwanda>
References: <20130504152058.GA20790@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130504152058.GA20790@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Source-IP: acsinet21.oracle.com [141.146.126.237]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, May 04, 2013 at 11:21:17AM -0400, Jake Champlin wrote:
> @@ -1802,10 +1803,11 @@ static inline void input_state_falling(struct logical_input *input)
>  
>  			if (input->u.kbd.repeat_str[0]) {
>  				char *repeat_str = input->u.kbd.repeat_str;
> -				if (input->high_timer >= KEYPAD_REP_START)
> +				if (input->high_timer >= KEYPAD_REP_START) {
> +					int s = sizeof(input->u.kbd.repeat_str);
>  					input->high_timer -= KEYPAD_REP_DELAY;
> -					keypad_send_key(repeat_str,
> -							sizeof(input->u.kbd.repeat_str));
> +					keypad_send_key(repeat_str, s);
> +				}


This looks like a bugfix.  Good job.  Please mention bug fixes in
the changelog next time.

regards,
dan carpenter


