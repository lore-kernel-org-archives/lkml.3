Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754039Ab3BCWdD (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Feb 2013 17:33:03 -0500
Received: from mga03.intel.com ([143.182.124.21]:3810 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753834Ab3BCWdA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Feb 2013 17:33:00 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,595,1355126400"; 
   d="scan'208";a="252102999"
Date: Sun, 3 Feb 2013 23:32:57 +0100
From: Samuel Ortiz <sameo@linux.intel.com>
To: Thierry Reding <thierry.reding@avionic-design.de>
Cc: linux-kernel@vger.kernel.org,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>
Subject: Re: [PATCH 16/33] mfd: Convert to devm_ioremap_resource()
Message-ID: <20130203223257.GA24304@sortiz-mobl>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
 <1358762966-20791-17-git-send-email-thierry.reding@avionic-design.de>
 <20130203172227.GS8476@sortiz-mobl>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130203172227.GS8476@sortiz-mobl>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, Feb 03, 2013 at 06:22:27PM +0100, Samuel Ortiz wrote:
> Hi Thierry,
> 
> On Mon, Jan 21, 2013 at 11:09:09AM +0100, Thierry Reding wrote:
> > Convert all uses of devm_request_and_ioremap() to the newly introduced
> > devm_ioremap_resource() which provides more consistent error handling.
> > 
> > devm_ioremap_resource() provides its own error messages so all explicit
> > error messages can be removed from the failure code paths.
> > 
> > Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
> > Cc: Samuel Ortiz <sameo@linux.intel.com>
> > ---
> >  drivers/mfd/intel_msic.c | 9 ++++-----
> >  1 file changed, 4 insertions(+), 5 deletions(-)
> Applied, thanks.
I just realized that this one will go through Greg's driver-core tree as it
has a build dependency on it. So dropped from my tree...

Cheers,
Samuel.

-- 
Intel Open Source Technology Centre
http://oss.intel.com/
