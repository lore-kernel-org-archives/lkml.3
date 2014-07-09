Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755782AbaGITRx (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Jul 2014 15:17:53 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:47437 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755337AbaGITRw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Jul 2014 15:17:52 -0400
Date: Wed, 9 Jul 2014 12:22:16 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: Sami Laine <laine.j.sami@gmail.com>
Cc: devel@driverdev.osuosl.org, trivial@kernel.org, gulsah.1004@gmail.com,
        linville@tuxdriver.com, linux-kernel@vger.kernel.org,
        paulmck@linux.vnet.ibm.com, Larry.Finger@lwfinger.net
Subject: Re: [PATCH next-20140704]: staging/rtl8821ae/base.c: sparse warning
 corrections
Message-ID: <20140709192216.GA32205@kroah.com>
References: <20140706090111.GA16760@acer>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140706090111.GA16760@acer>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Jul 06, 2014 at 12:01:11PM +0300, Sami Laine wrote:
> From: Sami Laine <laine.j.sami@gmail.com>
> 
> Sparse warning corrections for:
> 
> drivers/staging/rtl8821ae/base.c:1370:16: warning: symbol 'rtl_make_smps_action' was not declared. Should it be static?
> drivers/staging/rtl8821ae/base.c:1543:6: warning: symbol 'rtl_find_221_ie' was not declared. Should it be static?
> drivers/staging/rtl8821ae/base.c:1804:5: warning: symbol 'rtl_core_module_init' was not declared. Should it be static?
> drivers/staging/rtl8821ae/base.c:1820:6: warning: symbol 'rtl_core_module_exit' was not declared. Should it be static?
> 
> Signed-off-by: Sami Laine <laine.j.sami@gmail.com>

You obviously did not build the code with your patch applied, as it
breaks the build in bad ways :(

Please ALWAYS test your patches before sending them out...

greg k-h
