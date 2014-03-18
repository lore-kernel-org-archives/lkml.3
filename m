Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757431AbaCRUDh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Mar 2014 16:03:37 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:59656 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757114AbaCRUDf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Mar 2014 16:03:35 -0400
Date: Tue, 18 Mar 2014 13:05:37 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Masood Mehmood <ody.guru@gmail.com>
Cc: devel@driverdev.osuosl.org, lidza.louina@gmail.com, eng.linux@digi.com,
        driverdev-devel@linuxdriverproject.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgap: Fixed sparse error: same symbol
 redeclared with different type
Message-ID: <20140318200537.GA1834@kroah.com>
References: <1394704979-4466-1-git-send-email-ody.guru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394704979-4466-1-git-send-email-ody.guru@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 13, 2014 at 03:02:59AM -0700, Masood Mehmood wrote:
> sparse reported dgap_do_fep_load is redeclared with different type. while
> fixing, I noticed __user attribute is used incorrectly in declaration.
> There is no need to define __user for firware->data.
> 
> Replaced the __user with 'const uchar *' from function dgap_do_fep_load and
> did the same for function dgap_do_bios_load
> 
> patch generated against: next-20140317
> 
> Signed-off-by: Masood Mehmood <ody.guru@gmail.com>
> ---
>  drivers/staging/dgap/dgap.c | 13 ++++++-------
>  1 file changed, 6 insertions(+), 7 deletions(-)

This patch does not apply to my staging-next branch, sorry.  Please redo
it and resend.

thanks,

greg k-h
