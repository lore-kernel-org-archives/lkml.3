Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753113AbaF1QD3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Jun 2014 12:03:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52273 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751129AbaF1QD2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Jun 2014 12:03:28 -0400
Date: Sat, 28 Jun 2014 12:03:16 -0400
From: Greg KH <gregkh@linuxfoundation.org>
To: Guillaume Morin <guillaume@morinfr.org>
Cc: jic23@kernel.org, linux-iio@vger.kernel.org, linux-kernel@vger.kernel.org,
        mwelling@ieee.org
Subject: Re: [PATCH v4 1/1] staging: iio: ad9850.c: code cleanup
Message-ID: <20140628160316.GB11019@kroah.com>
References: <936f1ac494ee8708e37a8cb16a70aa3f007e93cd.1403966025.git.guillaume@morinfr.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <936f1ac494ee8708e37a8cb16a70aa3f007e93cd.1403966025.git.guillaume@morinfr.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sat, Jun 28, 2014 at 05:54:39PM +0200, Guillaume Morin wrote:
> checkpath.pl was complaining about value_mask:
> ERROR: Macros with complex values should be enclosed in parenthesis
> 
> I fixed this by simply removing it since it's not used (as well as another
> macro).  Got rid of the un-necessary error_ret label as well.
> 
> Signed-off-by: Guillaume Morin <guillaume@morinfr.org>
> Reported-by: Michael Welling <mwelling@ieee.org>
> ---
> Changes since v3:
> - Added Reported-by: Michael Welling <mwelling@ieee.org>
> 
>  drivers/staging/iio/frequency/ad9850.c |    6 ------
>  1 file changed, 6 deletions(-)

Very good, thanks for pushing through and doing this.

Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
