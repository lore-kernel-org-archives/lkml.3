Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaIHURD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 16:17:03 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:34797 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754254AbaIHURB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 16:17:01 -0400
Date: Mon, 8 Sep 2014 13:17:00 -0700
From: Greg KH <gregkh@linuxfoundation.org>
To: wfp5p@worldbroken.com
Cc: cascardo@linux.vnet.ibm.com, linux-serial@vger.kernel.org,
        linux-kernel@vger.kernel.org, lidza.louina@gmail.com,
        devel@driverdev.osuosl.org
Subject: Re: [Patch v2 0/2] Move Digi Neo card support from dgnc to jsm
Message-ID: <20140908201700.GA28282@kroah.com>
References: <1409430958-2692-1-git-send-email-wfp5p@worldbroken.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409430958-2692-1-git-send-email-wfp5p@worldbroken.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Aug 30, 2014 at 04:35:56PM -0400, wfp5p@worldbroken.com wrote:
> From: Bill Pemberton <wfp5p@worldbroken.com>
> 
> The jsm driver (drivers/tty/serial/jsm) already supports the Digi Neo
> cards that dgnc (staging) supports.  In fact, it appears that jsm was
> based on dgnc.  The dgnc driver has PCI ids for more cards than jsm,
> this patch moves support for all the Neo cards to jsm.
> 
> The result of this will be that dgnc will only support the Classic
> cards since the jsm driver doesn't support those cards yet.
> 
> 
> Bill Pemberton (2):
>   jsm: add support for additional Neo cards
>   staging: dgnc: remove Neo card ids from device table
> 
>  drivers/staging/dgnc/dgnc_driver.c  | 13 -------------
>  drivers/tty/serial/jsm/jsm.h        | 10 ++++++++++
>  drivers/tty/serial/jsm/jsm_driver.c | 38 +++++++++++++++++++++++++++++++++----
>  3 files changed, 44 insertions(+), 17 deletions(-)

These are now applied, thanks.

Do you think we can delete the dgnc driver now, or are there still some
odd cards out there that it only supports?  What would it take to move
that support to the jsm driver instead?

thanks,

greg k-h
