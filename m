Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752711AbaCQVeX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Mar 2014 17:34:23 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:48446 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750933AbaCQVeW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Mar 2014 17:34:22 -0400
Date: Mon, 17 Mar 2014 14:36:23 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Masood Mehmood <ody.guru@gmail.com>
Cc: eng.linux@digi.com, lidza.louina@gmail.com,
        driverdev-devel@linuxdriverproject.org, devel@driverdev.osuosl.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] staging: dgap: Fixed sparse error: same symbol
 redeclared with different type
Message-ID: <20140317213623.GA23629@kroah.com>
References: <1394682944-3134-1-git-send-email-ody.guru@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1394682944-3134-1-git-send-email-ody.guru@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Mar 12, 2014 at 08:55:44PM -0700, Masood Mehmood wrote:
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

This patch does not apply :(
