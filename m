Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753008AbaCJSzI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Mar 2014 14:55:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:39942 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752121AbaCJSzG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Mar 2014 14:55:06 -0400
Date: Mon, 10 Mar 2014 11:37:12 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Masood Mehmood <ody.guru@gmail.com>
Cc: devel@driverdev.osuosl.org, lidza.louina@gmail.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] staging: dgap: Fixed sparse error: same symbol
 redeclared with different type
Message-ID: <20140310183712.GA27534@kroah.com>
References: <1394349522-20458-1-git-send-email-ody.guru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394349522-20458-1-git-send-email-ody.guru@gmail.com>
User-Agent: Mutt/1.5.22 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Mar 08, 2014 at 11:18:42PM -0800, Masood Mehmood wrote:
> sparse reported dgap_do_fep_load is redeclared with different type. while
> fixing, I noticed __user attribute is used incorrectly in declaration.
> There is no need to define __user for firware->data.
> 
> Replaced the __user with 'const uchar *' from function dgap_do_fep_load and
> did the same for function dgap_do_bios_load.
> 
> Signed-off-by: Masood Mehmood <ody.guru@gmail.com>
> ---
>  drivers/staging/dgap/dgap.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)

I don't see a patch 1/2 here, did you forget to send it to me?

thanks,

greg k-h
