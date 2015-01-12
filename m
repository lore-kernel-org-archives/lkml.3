Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753363AbbALOhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 09:37:43 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:58350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750964AbbALOhm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 09:37:42 -0500
Date: Mon, 12 Jan 2015 06:37:41 -0800
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: Guenter Roeck <linux@roeck-us.net>
Cc: Pali =?iso-8859-1?Q?Roh=E1r?= <pali.rohar@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Steven Honeyman <stevenhoneyman@gmail.com>,
        Jean Delvare <jdelvare@suse.de>,
        Gabriele Mazzotta <gabriele.mzt@gmail.com>,
        Jochen Eisinger <jochen@penguin-breeder.org>, Valdis.Kletnieks@vt.edu,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 7/9] i8k: Autodetect fan RPM multiplier
Message-ID: <20150112143741.GA25806@kroah.com>
References: <1421069525-12875-1-git-send-email-pali.rohar@gmail.com>
 <1421069525-12875-8-git-send-email-pali.rohar@gmail.com>
 <54B3D7F3.9020504@roeck-us.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <54B3D7F3.9020504@roeck-us.net>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 06:19:31AM -0800, Guenter Roeck wrote:
> On 01/12/2015 05:32 AM, Pali Rohár wrote:
> >This patch adds new function i8k_get_fan_nominal_speed() for doing SMM call
> >which will return nominal fan RPM for specified fan speed. It returns nominal
> >RPM value at which fan operate when speed (0, 1, 2, 3) is set. It looks like
> >RPM value is not accurate, but still provides very useful information.
> >
> >New function i8k_get_fan_nominal_speed() is used for determinate if fan
> >multiplier is 1 or 30. If function for maximal fan value success and returned
> >RPM value too high (above 30000) then fan multiplier is set to 1. Otherwise
> >multiplier is not changed and default value 30 is used.
> >
> >Signed-off-by: Pali Rohár <pali.rohar@gmail.com>
> >Tested-by: Pali Rohár <pali.rohar@gmail.com>
> >Tested-by: Gabriele Mazzotta <gabriele.mzt@gmail.com>
> 
> Reviewed-by: Guenter Roeck <linux@roeck-us.net>
> 
> Greg,
> 
> with this the entire series is ready to go.

What about patch 9?  It doesn't have your ack.

thanks,

greg k-h
